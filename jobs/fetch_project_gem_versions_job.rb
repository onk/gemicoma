class FetchProjectGemVersionsJob < ApplicationJob
  queue_as :default

  def perform(args = {})
    args = args.with_indifferent_access
    project_id = args[:project_id]

    project = Project.find_by(id: project_id)
    unless project
      logger.warn "Unable to find project with id: #{project_id}"
      return
    end

    client = octokit_client(project)
    gemfile_body = fetch_gemfile(project, client)
    unless gemfile_body
      logger.warn "Unable to find Gemfile for #{project.full_name}"
      return
    end
    gemfile_lock_body = fetch_lockfile(project, client)
    unless gemfile_lock_body
      logger.warn "Unable to find Gemfile.lock for #{project.full_name}"
      return
    end

    gemfile_parser = Gemnasium::Parser.gemfile(gemfile_body)
    gemfile_lock_parser = Bundler::LockfileParser.new(gemfile_lock_body)
    project.import_project_gem_versions(gemfile_parser.dependencies, gemfile_lock_parser.specs)
  end

  private

    def fetch_gemfile(project, client)
      contents = client.contents(project.full_name, path: "#{project.path}/Gemfile")
      Base64.decode64(contents.content)
    rescue Octokit::NotFound
      nil
    end

    def fetch_lockfile(project, client)
      contents = client.contents(project.full_name, path: "#{project.path}/Gemfile.lock")
      Base64.decode64(contents.content)
    rescue Octokit::NotFound
      nil
    end

    def octokit_client(project)
      if project.site == "github.com"
        Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
      else
        Octokit::Client.new(
          access_token: ENV["GHE_TOKEN"], # TODO: configurable for each site
          api_endpoint: "https://#{project.site}/api/v3",
          web_endpoint: "https://#{project.site}/",
        )
      end
    end
end
