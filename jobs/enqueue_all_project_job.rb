class EnqueueAllProjectJob
  include Sidekiq::Worker

  def perform
    Project.all.find_each do |project|
      FetchProjectGemVersionsJob.perform_async(project_id: project.id)
    end
  end
end
