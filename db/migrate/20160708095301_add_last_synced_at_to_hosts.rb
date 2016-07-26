class AddLastSyncedAtToServers < ActiveRecord::Migration[5.0]
  def change
    add_column :servers, :last_synced_at, :datetime
  end
end
