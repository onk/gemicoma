class EnqueueAllProjectJob < ApplicationJob
  queue_as :default

  def perform
    Project.all.find_each do |project|
      FetchProjectGemVersionsJob.perform_async(project_id: project.id)
    end
  end
end
