class AddPluginsToHosts < ActiveRecord::Migration[5.0]
  def change
    add_column :hosts, :plugins, :string, array: true, default: []
  end
end
