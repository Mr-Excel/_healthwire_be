class AddColumnToLoginHistory < ActiveRecord::Migration[7.0]
  def change
    add_column :login_histories, :type, :string
  end
end
