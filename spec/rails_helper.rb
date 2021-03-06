# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'webmock/rspec'
require 'vcr'
require 'brakeman'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

def stub_omniauth
  omni_auth_config = OmniAuth.config
  omni_auth_config.test_mode = true
  omni_auth_config.mock_auth[:amazon_oauth] = OmniAuth::AuthHash.new(
    user_info: { provider: 'amazon_oauth',
                 uid: '1234567890',
                 info: { email: 'rickastley@gmail.com',
                         name: 'Rick Astley',
                         postal_code: '80202' },
                 credentials: { token: '12345678900987654321' } }
  )
end

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end

# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.before(:all) do
    DatabaseCleaner.clean
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each) do
    Rails.application.load_seed
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end

  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.after(:suite) do
    example_group = RSpec.describe('Brakeman Issues')
    example = example_group.example('must have 0 Critical Security Issues') do
      res = Brakeman.run app_path: "#{Rails.root}", output_files: ['brakeman.html'], print_report: true
      serious = res.warnings.count { |w| w.confidence == 0 }
      puts "\n\nBrakeman Result:\n Critical Security Issues = #{serious}"
      expect(serious).to eq(0)
    end
    example_group.run
    RSpec.configuration.reporter.example_failed example unless :passed
  end
end
