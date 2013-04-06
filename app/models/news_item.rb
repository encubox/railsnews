class NewsItem < ActiveRecord::Base
  attr_accessible :body, :title

  validates_presence_of :body, :title
end
