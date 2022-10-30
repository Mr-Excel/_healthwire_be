class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.boolean :is_active
      t.datetime :deleted_at

      

      t.timestamps
    end
  end
end
