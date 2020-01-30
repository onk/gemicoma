config_file = File.join(File.expand_path("..", __dir__), "redis.yml")
env = ENV["RACK_ENV"] || "development"
config = YAML.load(ERB.new(IO.read(config_file)).result)[env]
redis_sidekiq = { url: "redis://#{config["host"]}:#{config["port"]}/#{config["db"]}" }
Sidekiq.configure_server do |config|
  config.redis = redis_sidekiq

  # sidekiq-cron
  schedule_file = File.join(File.expand_path("..", __dir__), "schedule.yml")
  if File.exist?(schedule_file)
    hash = YAML.load(ERB.new(IO.read(schedule_file)).result)
    Sidekiq::Cron::Job.load_from_hash!(hash)
  end
end
Sidekiq.configure_client { |config| config.redis = redis_sidekiq }
