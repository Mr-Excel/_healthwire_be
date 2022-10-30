class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, default: ''
      t.string :password_digest, null: false, default: ''
      t.string :name, null: false, default: ''
      t.integer :role, null: false, default: ''
      t.string :gender, null: false, default: ''
      t.string :email, null: false, default: ''
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
  end
end
