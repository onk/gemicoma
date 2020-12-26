# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

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
gem "redis", "< 4.2" # wait for sidekiq v6.1 and sidekiq-cron
gem "sidekiq"
gem "sidekiq-cron"
gem "sinatra", require: false
gem "sinatra-activerecord"
gem "sinatra-contrib"
gem "sinatra-flash", require: ["sinatra/flash"]

group :test do
  # https://github.com/amatsuda/database_rewinder/pull/74
  gem "database_rewinder", github: "takkanm/database_rewinder", branch: "fix-error-on-edge-rails"
  gem "rack-test"
  gem "rspec", group: :development
  gem "rspec-request_describer"
end
