class RenameProjectNameToUrl < ActiveRecord::Migration[6.0]
  def change
    rename_column :projects, :name, :url
  end
end
