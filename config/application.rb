require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'will_paginate'
require 'will_paginate/active_record'  

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module DealSite
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.paths << Rails.root.join("app", "themes")
  end
end


