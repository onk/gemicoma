class CreateProjectGemVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :project_gem_versions do |t|
      t.bigint :project_id,     null: false, unsigned: true
      t.bigint :gem_version_id, null: false, unsigned: true
      t.string :locked_version, null: false
      t.timestamps

      t.index [:project_id, :gem_version_id], unique: true
      t.index :gem_version_id
    end
  end
end
