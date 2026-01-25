require "rubygems/remote_fetcher"
require_relative "application_job"
class FetchLatestGemVersionsJob < ApplicationJob
  queue_as :default

  def perform(args = {})
    source = URI.parse("https://rubygems.org/")
    remote = Bundler::Source::Rubygems::Remote.new(source)
    fetcher = Bundler::Fetcher.new(remote)
    specs = Bundler.rubygems.fetch_specs(remote, "specs", fetcher.gem_remote_fetcher)
    GemVersion.import_specs(specs)
  end
end
