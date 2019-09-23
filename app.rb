require "bundler"
Bundler.require(:default, ENV["RACK_ENV"] || "development")

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
end
