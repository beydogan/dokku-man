class UpdateServerForApi < ActiveRecord::Migration[5.0]
  def change
    remove_column :servers, :private_key, :text
    remove_column :servers, :public_key, :text
    remove_column :servers, :username, :string
    add_column :servers, :endpoint, :string
    add_column :servers, :api_key, :string
    add_column :servers, :api_secret, :string
  end
end
