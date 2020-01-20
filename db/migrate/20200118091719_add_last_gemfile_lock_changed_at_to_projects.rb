class AddLastGemfileLockChangedAtToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :last_gemfile_lock_changed_at, :datetime, after: :last_sync_at
  end
end
