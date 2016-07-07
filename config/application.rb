require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DokkuMan
  class Application < Rails::Application

    config.generators do |g|
      g.test_framework  false
      g.view_specs      false
      g.helper_specs    false
    end

  end
end
