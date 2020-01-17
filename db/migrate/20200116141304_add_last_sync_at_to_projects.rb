class AddLastSyncAtToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :last_sync_at, :datetime, after: :url
  end
end
