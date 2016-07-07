class AddUserToHosts < ActiveRecord::Migration[5.0]
  def change
    add_column :hosts, :username, :string
  end
end
