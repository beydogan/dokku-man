class AddScaleToApps < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'hstore'
    add_column :apps, :scale, :hstore, default: {}, null: false
  end
end
