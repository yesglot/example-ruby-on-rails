require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module ExampleProject
  class Application < Rails::Application
    config.load_defaults 7.1

    config.i18n.available_locales = %i[en es tr]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true
  end
end
