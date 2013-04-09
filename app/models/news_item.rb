class NewsItem < ActiveRecord::Base

  belongs_to :user

  attr_accessible :body, :title

  validates_presence_of :body, :title
  
end
