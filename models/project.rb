class Project < ActiveRecord::Base
  has_many :project_gem_versions

  def import_project_gem_versions(specs)
    db_project_gem_versions_idx = project_gem_versions.preload(:gem_version).
      index_by {|pgv| pgv.gem_version.name }

    deleted_gem_names = db_project_gem_versions_idx.keys - specs.map(&:name)
    deleted_gem_names.each do |gem_name|
      db_project_gem_versions_idx[gem_name].destroy!
    end

    specs.each do |spec|
      pgv = db_project_gem_versions_idx[spec.name]
      unless pgv
        # create: gems not found in rubygems.org
        gem_version = GemVersion.find_or_create_by(name: spec.name, version: spec.version.to_s)
        pgv = self.project_gem_versions.new(gem_version: gem_version)
      end
      pgv.locked_version = spec.version.to_s
      pgv.save!
    end
  end
end
