class FetchLatestGemVersionsJob
  include Sidekiq::Worker

  def perform(args = {})
    source = URI.parse("https://rubygems.org")
    specs = fetch_specs(source, "specs")
    GemVersion.import_specs(specs)
  end

  private

    # https://github.com/bundler/bundler/blob/v2.0.2/lib/bundler/rubygems_integration.rb#L754-L763
    def fetch_specs(source, name)
      path = source + "#{name}.#{Gem.marshal_version}.gz"
      fetcher = gem_remote_fetcher
      string = fetcher.fetch_path(path)
      Bundler.load_marshal(string)
    end

    def gem_remote_fetcher
      require "resolv"
      proxy = Gem.configuration[:http_proxy]
      dns = Resolv::DNS.new
      Bundler::GemRemoteFetcher.new(proxy, dns)
    end
end
