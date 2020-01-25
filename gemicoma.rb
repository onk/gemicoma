require "bundler"
Bundler.require(:default, ENV["RACK_ENV"] || "development")

# initializers
Dir.glob("config/initializers/*").each { |f| require_relative f }
# load models
Dir.glob("models/**/*").each { |f| require_relative f }
Dir.glob("jobs/**/*").each { |f| require_relative f }

class Gemicoma < Sinatra::Base
  set :method_override, true # POST _method hack
  set :sessions, true
  set :database_file, "config/database.yml"
  register Sinatra::ActiveRecordExtension
  register Sinatra::Flash

  configure :development do
    register Sinatra::Reloader
    also_reload "models/**/*"
    also_reload "jobs/**/*"
  end

  helpers do
    def l(object, **kwargs)
      object.nil? ? "" : I18n.l(object, **kwargs)
    end

    def span(klass: )
      %Q(<span class="#{klass}"></span>)
    end

    def status_tag(status)
      case status
      when ProjectGemVersion::Status::OUTDATED
        span(klass: "circle gray") + span(klass: "circle gray") + span(klass: "circle red")
      when ProjectGemVersion::Status::BEHIND
        span(klass: "circle gray") + span(klass: "circle yellow") + span(klass: "circle gray")
      when ProjectGemVersion::Status::LATEST
        span(klass: "circle green") + span(klass: "circle gray") + span(klass: "circle gray")
      else
        nil
      end
    end

    def host_image_tag(host)
      if File.exists?(File.join(settings.public_folder, "#{host}.png"))
        %Q(<img src="/#{host}.png" width="32" height="32">)
      else
        host
      end
    end
  end

  get "/" do
    @projects = Project.preload(:project_gem_versions => :gem_version).all.sort_by {|proj|
      [
        # percent desc, last_changed_at desc, name asc
        proj.status_percentage.nan? ? 1 : -proj.status_percentage,
        proj.last_gemfile_lock_changed_at ? -proj.last_gemfile_lock_changed_at.to_f : 1,
        proj.name,
      ]
    }
    erb :"projects/index"
  end

  get "/projects/:id" do
    @project = Project.preload(:project_gem_versions => :gem_version).find(params[:id])
    erb :"projects/show"
  end

  post "/projects" do
    project_params = {
      url: params[:url]
    }
    Project.create!(project_params)
    redirect "/"
  rescue ActiveRecord::RecordNotUnique
    flash[:alert] = "#{params[:url]} is already exists."
    redirect "/"
  end

  delete "/projects/:id" do
    project = Project.find(params[:id])
    project.destroy!
    redirect "/"
  end

  post "/projects/:id/sync" do
    project = Project.find(params[:id])
    FetchProjectGemVersionsJob.perform_async(project_id: project.id)
    flash[:notice] = "Sync job was successfully enqueued."
    redirect "/projects/#{project.id}"
  end
end
