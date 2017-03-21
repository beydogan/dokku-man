class CreateServerLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :server_logs do |t|
      t.references :server, foreign_key: true
      t.string :action
      t.text :details
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
