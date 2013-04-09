class AddUserIdToNewsItems < ActiveRecord::Migration
  def change
  	add_column :news_items, :user_id, :integer  	   
    add_index :news_items, :user_id
  end
end
