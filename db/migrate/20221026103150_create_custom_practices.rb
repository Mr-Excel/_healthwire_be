class CreateCustomPractices < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_practices do |t|
      t.string :name
      
      t.timestamps
    end
  end
end
