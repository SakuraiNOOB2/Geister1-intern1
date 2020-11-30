require 'simplecov'

if ENV['COVERAGE']
  SimpleCov.start 'rails' do
    add_filter '/spec/'
    add_filter '/vendor/'
    add_filter '/app/channels'
    add_filter '/app/jobs'
    add_filter '/app/mailers'
    add_filter '/lib/generators'
    add_filter '/lib/rack/request_logger'
  end
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'rspec/json_matcher'
require 'shoulda-matchers'
require 'database_cleaner'
require 'timecop'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include RSpec::JsonMatcher
  config.include FactoryGirl::Syntax::Methods
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
