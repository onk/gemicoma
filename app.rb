require "bundler"
Bundler.require(:default, ENV["RACK_ENV"] || "development")

# initializers
Dir.glob("config/initializers/*").each { |f| require_relative f }
# load models
Dir.glob("models/**/*").each { |f| require_relative f }
Dir.glob("jobs/**/*").each { |f| require_relative f }

class App < Sinatra::Base
  set :method_override, true # POST _method hack
  set :database_file, "config/database.yml"
  register Sinatra::ActiveRecordExtension

  configure :development do
    register Sinatra::Reloader
  end

  get "/" do
    @projects = Project.all
    erb :"projects/index"
  end

  get "/projects/:id" do
    @project = Project.find(params[:id])
    erb :"projects/show"
  end

  post "/projects" do
    project_params = {
      url: params[:url]
    }
    Project.create!(project_params)
    redirect "/"
  end

  delete "/projects/:id" do
    project = Project.find(params[:id])
    project.destroy!
    redirect "/"
  end
end
