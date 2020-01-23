require File.join(__dir__, "gemicoma")
require "sidekiq/web"
require "sidekiq/cron/web"

run Rack::URLMap.new(
  "/" => Gemicoma,
  "/sidekiq" => Sidekiq::Web,
)
