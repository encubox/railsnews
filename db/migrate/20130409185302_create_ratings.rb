class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :news_item
      t.integer :value

      t.timestamps
    end
    add_index :ratings, :news_item_id
  end
end
