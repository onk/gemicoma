class Project < ActiveRecord::Base
  acts_as_paranoid

  before_destroy :set_is_active_to_null
  before_recover :set_is_active_to_true

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

  private

    # is_active becomes null when the project is deleted.
    # This makes [:url] unique constraint for only active project.
    def set_is_active_to_null
      self.update!(is_active: nil)
    end

    # @see set_is_active_to_null
    def set_is_active_to_true
      self.is_active = true
    end
end
