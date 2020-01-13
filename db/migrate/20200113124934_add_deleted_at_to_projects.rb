class AddDeletedAtToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :deleted_at, :datetime, after: :url
  end
end
