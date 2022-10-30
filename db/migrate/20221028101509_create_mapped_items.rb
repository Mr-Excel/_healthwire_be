class CreateMappedItems < ActiveRecord::Migration[7.0]
  def change
    create_table :mapped_items do |t|
      t.integer :formatted_item_id
      t.integer :default_item_id
      t.integer :custom_practice_id
      
      t.timestamps
    end
  end
end

# 27620
# 87870