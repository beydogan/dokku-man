class AddKeysToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :private_key, :text
    add_column :apps, :public_key, :text
  end
end
