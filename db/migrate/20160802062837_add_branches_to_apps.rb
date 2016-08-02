class AddBranchesToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :branches, :string, array: true
  end
end
