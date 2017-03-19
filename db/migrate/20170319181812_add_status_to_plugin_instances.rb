class AddStatusToPluginInstances < ActiveRecord::Migration[5.0]
  def change
    remove_column :plugin_instances, :status, :string
    add_column :plugin_instances, :status, :integer, default: 0
  end
end
