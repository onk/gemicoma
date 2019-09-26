class FetchProjectGemVersionsJob
  include Sidekiq::Worker

  def perform(args = {})
      args = args.with_indifferent_access
      project_id = args[:project_id]

      project = Project.find_by(id: project_id)
      unless project
        logger.warn "Unable to find project with id: #{project_id}"
        return
      end

      gemfile_lock_body = fetch_lockfile(project)
      unless gemfile_lock_body
        logger.warn "Unable to find Gemfile.lock for #{project.name}"
        return
      end

      parser = Bundler::LockfileParser.new(gemfile_lock_body)
      project.import_project_gem_versions(parser.specs)
  end


  private

    def fetch_lockfile(project)
      client = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
      contents = client.contents(project.name, path: "/Gemfile.lock")
      Base64.decode64(contents.content)
    rescue Octokit::NotFound
      nil
    end
end
