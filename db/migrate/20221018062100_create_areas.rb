class CreateAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :areas do |t|
      
      t.string :name
      t.string :address 
      t.integer :level
      t.string :lon
      t.string :lat
      t.string :alt_name
      t.string :slug
      t.integer :parent_id
    
      t.timestamps
    end
  end
end
