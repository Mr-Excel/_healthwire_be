class AddTeamsToSalePerson < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :team, index: true, foreign_key: true
  end
end
