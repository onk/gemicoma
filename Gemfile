# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "activejob", require: ["active_job"]
gem "activerecord"
gem "activerecord-simple_index_name"
gem "acts_as_paranoid"
gem "bundler-audit"
gem "gemnasium-parser"
gem "i18n"
gem "octokit"
gem "omniauth"
gem "omniauth-github"
gem "puma"
gem "rackup"
gem "rake"
gem "redis"
gem "sidekiq"
gem "sidekiq-cron"
gem "sinatra", require: false
gem "sinatra-activerecord"
gem "sinatra-contrib"
gem "sinatra-flash", require: ["sinatra/flash"]
gem "trilogy"

group :test do
  gem "database_rewinder"
  gem "rack-test"
  gem "rspec", group: :development
  gem "rspec-request_describer"
end
