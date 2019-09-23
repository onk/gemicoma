class GemVersion < ActiveRecord::Base
  has_many :project_gem_versions
end
