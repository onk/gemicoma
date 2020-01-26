require "rubygems/remote_fetcher"

class FetchLatestGemVersionsJob
  include Sidekiq::Worker

  def perform(args = {})
    source = URI.parse("https://rubygems.org/")
    remote = Bundler::Source::Rubygems::Remote.new(source)
    specs = Bundler.rubygems.fetch_specs(remote, "specs")
    GemVersion.import_specs(specs)
  end
end
