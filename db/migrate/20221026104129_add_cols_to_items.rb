class AddColsToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :formatted_items, :remaining_name, :string
    add_column :formatted_items, :second_name, :string
    add_column :default_items, :remaining_name, :string
    add_column :default_items, :second_name, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
