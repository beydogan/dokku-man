class ChangeServersPluginsToJson < ActiveRecord::Migration[5.0]
  def change
    remove_column :servers, :plugins, :array
    add_column :servers, :plugins, :json, default: {}
  end
end
