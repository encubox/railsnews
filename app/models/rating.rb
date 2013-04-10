class Rating < ActiveRecord::Base
  belongs_to :news_item

  validates_presence_of :news_item_id, :value, :ip
end
