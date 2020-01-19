require "sinatra/activerecord/rake"
require "rspec/core/rake_task"

namespace :db do
  task :load_config do
    require File.join(__dir__, "app")
  end
end

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
