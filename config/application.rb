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

    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths << "#{Rails.root}/lib"
    config.autoload_paths << "#{Rails.root}/interactors"
  end
end
