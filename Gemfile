# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "activejob", require: ["active_job"]
gem "activerecord"
gem "activerecord-quiet_schema_version"
gem "activerecord-simple_index_name"
gem "acts_as_paranoid"
gem "bundler-audit"
gem "gemnasium-parser"
gem "i18n"
gem "mysql2"
gem "octokit"
gem "omniauth"
gem "omniauth-github"
gem "rake"
gem "redis"
gem "sidekiq"
gem "sidekiq-cron"
gem "sinatra", require: false
gem "sinatra-activerecord"
gem "sinatra-contrib"
gem "sinatra-flash", require: ["sinatra/flash"]

group :test do
  gem "database_rewinder"
  gem "rack-test"
  gem "rspec", group: :development
  gem "rspec-request_describer"
end
