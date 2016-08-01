class AddGitUrlToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :git_url, :string
  end
end
