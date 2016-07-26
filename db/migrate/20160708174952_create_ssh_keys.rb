class CreateSshKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :ssh_keys do |t|
      t.string :name
      t.text :key
      t.string :fingerprint
      t.references :server, foreign_key: true

      t.timestamps
    end
  end
end
