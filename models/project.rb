class Project < ActiveRecord::Base
  acts_as_paranoid

  before_destroy :set_is_active_to_null
  before_recover :set_is_active_to_true

  has_many :project_gem_versions
  has_many :ignore_advisories

  def url
    u = "https://#{site}/#{full_name}"
    if path.empty?
      u
    else
      "#{u}/blob/master/#{path}"
    end
  end

  def import_project_gem_versions(dependencies, specs)
    dependencies_idx = dependencies.index_by(&:name)
    db_project_gem_versions_idx = project_gem_versions.preload(:gem_version).
      index_by {|pgv| pgv.gem_version.name }

    deleted_gem_names = db_project_gem_versions_idx.keys - specs.map(&:name)
    deleted_gem_names.each do |gem_name|
      db_project_gem_versions_idx[gem_name].destroy!
    end

    now = Time.current
    project_gem_versions = []
    specs.each do |spec|
      pgv = db_project_gem_versions_idx[spec.name]
      unless pgv
        # create: gems not found in rubygems.org
        gem_version = GemVersion.find_or_create_by(name: spec.name) {|gem| gem.version = spec.version.to_s }
        pgv = ProjectGemVersion.new(project: self, gem_version: gem_version)
      end
      pgv.locked_version = spec.version.to_s
      if dependencies_idx[spec.name]
        pgv.specified_version = dependencies_idx[spec.name].requirement.to_s
      end
      if pgv.changed?
        pgv.created_at ||= now
        pgv.updated_at = now
        project_gem_versions << pgv.attributes
      end
    end
    unless project_gem_versions.empty?
      ProjectGemVersion.upsert_all(project_gem_versions)
      self.last_gemfile_lock_changed_at = now
    end

    self.last_sync_at = now
    self.save!
  end

  def status_percentage
    @status_percentage ||= begin
      # ignore UNKNOWN
      statuses = self.project_gem_versions.map(&:status).select {|s| s != ProjectGemVersion::Status::UNKNOWN }
      (statuses.count(ProjectGemVersion::Status::LATEST) / statuses.count.to_f * 100).round(3)
    end
  end

  def advisories
    project_gem_versions.flat_map {|pgv| pgv.advisories }
  end

  private

    # is_active becomes null when the project is deleted.
    # This makes [:site, :full_name] unique constraint for only active project.
    def set_is_active_to_null
      self.update!(is_active: nil)
    end

    # @see set_is_active_to_null
    def set_is_active_to_true
      self.is_active = true
    end
end
