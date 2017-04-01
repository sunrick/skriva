require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

module Skriva
  class Engine < ::Rails::Engine
    isolate_namespace Skriva

    initializer 'skriva.assets.precompile' do |app|
      app.config.assets.paths << root.join('assets', 'stylesheets').to_s
    end

    initializer 'skriva.setup' do |app|
      Skriva.setup!
    end

  end
end
