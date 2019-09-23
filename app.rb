require "bundler"
Bundler.require(:default, ENV["RACK_ENV"] || "development")

# initializers
Dir.glob("config/initializers/*").each { |f| require_relative f }
# load models
Dir.glob("models/**/*").each { |f| require_relative f }
Dir.glob("jobs/**/*").each { |f| require_relative f }

class App < Sinatra::Base
  set :database_file, "config/database.yml"
  register Sinatra::ActiveRecordExtension

  configure :development do
    register Sinatra::Reloader
  end
end
