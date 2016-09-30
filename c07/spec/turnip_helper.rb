require 'capybara/dsl'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'selenium-webdriver'
require 'turnip'
require 'turnip/capybara'

Dir.glob('spec/steps/**/*steps.rb') { |f| load f, true }

# setup selenium
# Capybara.default_driver = :selenium
# Capybara.ignore_hidden_elements = true
# Capybara.run_server = true
#
# Capybara.register_driver :selenium do |app|
#   Capybara::Selenium::Driver.new(app, browser: :chrome)
# end

# setup poltergeist (HEADLESS)
Capybara.run_server = true
Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, timeout: 60)
end
