ENV["APP_ENV"] ||= "test"
Bundler.require(:default, "test")
# load sinatra app
require_relative "../gemicoma"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  if config.files_to_run.one?
    config.default_formatter = "doc"
  end
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed

  ApplicationJob.queue_adapter = :test

  config.before(:suite) do
    DatabaseRewinder.clean_all
  end

  config.after(:each) do
    DatabaseRewinder.clean
    ApplicationJob.queue_adapter.enqueued_jobs.clear
  end

  config.include Rack::Test::Methods, type: :request
  config.include RSpec::RequestDescriber, type: :request
end
