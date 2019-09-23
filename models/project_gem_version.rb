class ProjectGemVersion < ActiveRecord::Base
  belongs_to :gem_version
  belongs_to :project
end
