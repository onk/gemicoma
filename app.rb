require "bundler"
Bundler.require(:default, ENV["RACK_ENV"] || "development")

# load models
Dir.glob("models/**/*").each { |f| require_relative f }

class App < Sinatra::Base
  set :database_file, "config/database.yml"
  register Sinatra::ActiveRecordExtension

  configure :development do
    register Sinatra::Reloader
  end
end
