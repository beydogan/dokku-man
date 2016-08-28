class AddUserRefToServers < ActiveRecord::Migration[5.0]
  def change
    add_reference :servers, :user, foreign_key: true
  end
end
