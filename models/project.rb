class Project < ActiveRecord::Base
  has_many :project_gem_versions

  def host
    uri.host
  end

  def name
    uri.path.sub(%r{^/}, "")
  end

  def uri
    @uri ||= URI.parse(url)
  end

  def import_project_gem_versions(specs)
    db_project_gem_versions_idx = project_gem_versions.preload(:gem_version).
      index_by {|pgv| pgv.gem_version.name }

    deleted_gem_names = db_project_gem_versions_idx.keys - specs.map(&:name)
    deleted_gem_names.each do |gem_name|
      db_project_gem_versions_idx[gem_name].destroy!
    end

    now = Time.current
    project_gem_versions = specs.map do |spec|
      pgv = db_project_gem_versions_idx[spec.name]
      unless pgv
        # create: gems not found in rubygems.org
        gem_version = GemVersion.find_or_create_by(name: spec.name) {|gem| gem.version = spec.version.to_s }
        pgv = self.project_gem_versions.new(gem_version: gem_version)
      end
      pgv.locked_version = spec.version.to_s
      pgv.created_at ||= now
      pgv.updated_at = now
      pgv.attributes
    end
    ProjectGemVersion.upsert_all(project_gem_versions)
  end
end
