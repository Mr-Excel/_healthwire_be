class AddKeysToItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :default_items, :custom_practice, index: true, foreign_key: true
    add_reference :formatted_items, :custom_practice, index: true, foreign_key: true
  end
end
