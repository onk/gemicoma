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
end
