class AddTimestampToServerLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :server_logs, :timestamp, :datetime
  end
end
