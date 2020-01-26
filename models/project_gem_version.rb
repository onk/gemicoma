class ProjectGemVersion < ActiveRecord::Base
  belongs_to :gem_version
  belongs_to :project

  module Status
    OUTDATED = 0
    BEHIND   = 1
    LATEST   = 2
    UNKNOWN  = 3
  end

  def status
    _locked_version  = Gem::Version.new(locked_version)
    current_version = Gem::Version.new(gem_version.version)

    return Status::UNKNOWN unless _locked_version && current_version
    return Status::LATEST if current_version <= _locked_version

    # approximate_recommendation is "~> x.y.z"
    # not satisfied by approximate_recommendation = major version is up = OUTDATED
    locked_requirement = Gem::Requirement.new(_locked_version.approximate_recommendation)
    locked_requirement.satisfied_by?(current_version) ? Status::BEHIND : Status::OUTDATED
  end

  def self.advisory_database
    @database ||= begin
      root_path = File.expand_path("..", __dir__)
      Bundler::Audit::Database.new(File.join(root_path, "tmp", "ruby-advisory-db"))
    end
  end

  # database.checkgem require [name: String, version: Gem::Version] object
  TempGem = Struct.new(:name, :version)
  def advisories
    @advisories ||= ProjectGemVersion.advisory_database.check_gem(TempGem.new(gem_version.name, Gem::Version.new(locked_version))).to_a
  end
end
