class CreateAudits < ActiveRecord::Migration[7.0]
  def change
    create_table :audits do |t|

      t.integer :table_id
      t.string :table_name
      t.integer :method # NEW | EDIT | DELETE
      t.string :payload
      
      t.timestamps
    end
  end
end
