class AddUserToServers < ActiveRecord::Migration[5.0]
  def change
    add_column :servers, :username, :string
  end
end
