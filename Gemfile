# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "activerecord"
gem "activerecord-quiet_schema_version"
gem "activerecord-simple_index_name"
gem "acts_as_paranoid"
gem "mysql2"
gem "octokit"
gem "sidekiq"
gem "sidekiq-cron"
gem "sinatra", require: false
gem "sinatra-activerecord"
gem "sinatra-contrib"
gem "sinatra-flash", require: ["sinatra/flash"]

group :development do
  gem "rake"
end

group :test do
  gem "database_rewinder"
  gem "rspec", group: :development
end
