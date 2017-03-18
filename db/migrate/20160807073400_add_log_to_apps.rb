class AddLogToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :log, :text
  end
end
