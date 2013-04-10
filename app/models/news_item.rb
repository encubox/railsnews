class NewsItem < ActiveRecord::Base
  # Model is not optimized for highload. In case of highload denormalization must be used.

  belongs_to :user
  has_many :ratings  

  attr_accessible :body, :title

  validates_presence_of :body, :title
  
  def average_rating
  	ratings.average('value').to_i
  end

	def allowed_to_rate?(ip, user = nil)
		if user.present?
			if ratings.find_by_user_id(user.id).present?
				false
			else
				true
			end			
		else
			if ratings.find_by_ip(ip).present?
				false
			else
				true
			end
		end
	end

	# I don't have time to rewrite this method using pure ActiveRecord without SQL :(
	def self.ordered_by_rating_and_date(user = nil)
		if user.present?						
			# ORDER BY does not want to work with LEFT JOIN and GROUP BY
			# NewsItem.find_by_sql(['SELECT news_items.*, AVG(ratings.value) as avg_rating FROM news_items LEFT JOIN ratings ON news_items.id = ratings.id WHERE news_items.user_id = ? GROUP BY news_items.id ORDER BY avg_rating DESC, created_at DESC', user.id])

			NewsItem.find_by_sql(['SELECT news_items.*, (SELECT AVG(ratings.value) FROM ratings WHERE ratings.news_item_id = news_items.id GROUP BY ratings.news_item_id) AS avg_rating FROM news_items WHERE news_items.user_id = ? ORDER BY avg_rating DESC, news_items.created_at DESC', user.id])
		else
			# ORDER BY does not want to work with LEFT JOIN and GROUP BY
			# NewsItem.find_by_sql('SELECT news_items.*, AVG(ratings.value) as avg_rating FROM news_items LEFT JOIN ratings ON news_items.id = ratings.id GROUP BY news_items.id ORDER BY avg_rating DESC, created_at DESC')

			NewsItem.find_by_sql('SELECT news_items.*, (SELECT AVG(ratings.value) FROM ratings WHERE ratings.news_item_id = news_items.id GROUP BY ratings.news_item_id) AS avg_rating FROM news_items ORDER BY avg_rating DESC, news_items.created_at DESC')
		end
	end
end
