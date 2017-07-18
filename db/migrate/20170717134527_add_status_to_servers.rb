class AddStatusToServers < ActiveRecord::Migration[5.0]
  def change
    add_column :servers, :status, :integer, default: 0
  end
end
