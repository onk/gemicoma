class AddPathToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :path, :string, null: false, default: "", after: :full_name
    remove_index :projects, :site_and_full_name_and_is_active
    add_index :projects, [:site, :full_name, :path, :is_active], unique: true
  end
end
