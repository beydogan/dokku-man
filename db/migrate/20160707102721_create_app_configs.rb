class CreateAppConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :app_configs do |t|
      t.string :name
      t.string :value
      t.references :app, foreign_key: true

      t.timestamps
    end
  end
end
