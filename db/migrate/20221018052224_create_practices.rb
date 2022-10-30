class CreatePractices < ActiveRecord::Migration[7.0]
  def change
    create_table :practices do |t|
      t.integer :doctor_id
      t.string :doctor_name
      t.string :doctor_slug
      t.string :doctor_gender
      t.integer :practice_id
      t.string :practice_name
      t.integer :doctor_fee
      t.boolean :listed_status
      t.float :doctor_experience
      t.string :doctor_degree
      t.string :practice_address
      t.integer :practice_area_id
      t.integer :practice_city_id
      t.string :practice_city_name
      t.string :doctor_specialities
      t.string :doctor_timings
      t.boolean :is_active
      
      t.timestamps
    end
  end
end
