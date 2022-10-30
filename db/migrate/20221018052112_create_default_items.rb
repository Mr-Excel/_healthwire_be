class CreateDefaultItems < ActiveRecord::Migration[7.0]
  def change
    create_table :default_items do |t|
      t.string :item_name
      t.integer :custom_id
      t.integer :quantity
      t.string :categories
      t.string :param_type
      t.float :param_value
      t.string :name
      # t.references :practice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
