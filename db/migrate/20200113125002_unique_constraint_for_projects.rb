class UniqueConstraintForProjects < ActiveRecord::Migration[6.0]
  def change
    # is_active becomes null when the project is deleted.
    # This makes [:url] unique constraint for only active project.
    add_column :projects, :is_active, :boolean, default: true, after: :deleted_at
    add_index :projects, [:url, :is_active], unique: true
  end
end
