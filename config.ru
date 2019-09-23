require File.join(__dir__, "app")
require "sidekiq/web"
require "sidekiq/cron/web"

run Rack::URLMap.new(
  "/" => App,
  "/sidekiq" => Sidekiq::Web,
)
