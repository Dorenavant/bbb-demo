require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BbbDemo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.bigbluebutton_endpoint = ENV["BIGBLUEBUTTON_ENDPOINT"] || "http://test-install.blindsidenetworks.com/bigbluebutton/"
    config.bigbluebutton_secret = ENV["BIGBLUEBUTTON_SECRET"] || "8cd8ef52e8e101574e400365b55e11a6"
    config.bigbluebutton_version = ENV["BIGBLUEBUTTON_VERSION"] || "0.9"

    config.demo_moderator_pw = ENV["DEMO_MODERATOR_PW"] || "mpw"
    config.demo_attendee_pw = ENV["DEMO_ATTENDEE_PW"] || "apw"
  end
end
