class CreateServerCommands < ActiveRecord::Migration[5.0]
  def change
    create_table :server_commands do |t|
      t.references :server, foreign_key: true
      t.string :command
      t.string :token
      t.datetime :ran_at
      t.text :result
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
