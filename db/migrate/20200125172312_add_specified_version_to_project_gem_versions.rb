class AddSpecifiedVersionToProjectGemVersions < ActiveRecord::Migration[6.0]
  def change
    add_column :project_gem_versions, :specified_version, :string, after: :gem_version_id
  end
end
