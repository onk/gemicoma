require_relative "application_job"
class FetchRubyAdvisoryDbJob < ApplicationJob
  queue_as :default

  # fetch ruby-advisory-db into tmp/ruby-advisory-db
  def perform(args = {})
    if repo_mirror_exists?
      update_mirror
    else
      clone_repo
    end
  end

  private

    def repo_path
      root_path = File.expand_path("..", __dir__)
      File.join(root_path, "tmp", "ruby-advisory-db")
    end

    def git_repo_url
      "https://github.com/rubysec/ruby-advisory-db.git"
    end

    def repo_mirror_exists?
      File.exist?(repo_path)
    end

    def clone_repo
      system("git clone --depth 1 --no-single-branch #{git_repo_url} #{repo_path}")
    end

    def update_mirror
      Dir.chdir(repo_path) do
        system("git fetch --depth 1 origin master")
      end
    end
end
