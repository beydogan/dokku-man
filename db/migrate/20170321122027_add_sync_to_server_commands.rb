class AddSyncToServerCommands < ActiveRecord::Migration[5.0]
  def change
    add_column :server_commands, :sync, :boolean, default: false
  end
end
