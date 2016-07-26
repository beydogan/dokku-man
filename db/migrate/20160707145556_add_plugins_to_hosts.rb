class AddPluginsToServers < ActiveRecord::Migration[5.0]
  def change
    add_column :servers, :plugins, :string, array: true, default: []
  end
end
