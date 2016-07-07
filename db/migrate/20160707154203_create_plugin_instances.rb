class CreatePluginInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :plugin_instances do |t|
      t.string :name
      t.string :type
      t.references :app, foreign_key: true
      t.references :host, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
