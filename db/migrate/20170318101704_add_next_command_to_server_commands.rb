class AddNextCommandToServerCommands < ActiveRecord::Migration[5.0]
  def change
    add_reference :server_commands, :next_command, references: :server_commands
  end
end
