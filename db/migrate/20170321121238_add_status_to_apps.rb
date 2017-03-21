class AddStatusToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :status, :integer, default: 0
  end
end
