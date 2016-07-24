class AddUserRefToHosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :hosts, :user, foreign_key: true
  end
end
