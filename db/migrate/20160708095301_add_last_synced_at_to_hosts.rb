class AddLastSyncedAtToHosts < ActiveRecord::Migration[5.0]
  def change
    add_column :hosts, :last_synced_at, :datetime
  end
end
