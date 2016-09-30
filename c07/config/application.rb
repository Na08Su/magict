require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.

Bundler.require(*Rails.groups)

module Zeno
  class Application < Rails::Application
    config.i18n.default_locale = :ja
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += Dir["#{ config.root }/lib/**/"]
    config.autoload_paths += Dir["#{ config.root }/app/validators"]
    config.autoload_paths += Dir["#{ config.root }/app/models/forms"]
    config.action_view.field_error_proc = proc do |html_tag, _|
      "<span class=\"field_with_errors\">#{ html_tag }</span>".html_safe
    end
  end
end
