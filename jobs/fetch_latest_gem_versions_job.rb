require "rubygems/remote_fetcher"
require_relative "application_job"
class FetchLatestGemVersionsJob < ApplicationJob
  queue_as :default

  def perform(args = {})
    source = URI.parse("https://rubygems.org/")
    remote = Bundler::Source::Rubygems::Remote.new(source)
    specs = Bundler.rubygems.fetch_specs(remote, "specs")
    GemVersion.import_specs(specs)
  end
end
