module SimplePresenter
  class Railtie < Rails::Railtie
    config.simple_presenter = ActiveSupport::OrderedOptions.new
  end

  class Base
    delegate :translate, :t, :localize, :l, :to => :helpers

    def self.routes_module
      @routes_module ||= Module.new do
        include Rails.application.routes.url_helpers
        include UrlMethods
      end
    end

    def self.routes
      @routes ||= Object.new.extend(routes_module)
    end

    def routes
      self.class.routes
    end
    alias_method :r, :routes

    def helpers
      ApplicationController.helpers
    end
    alias_method :h, :helpers
  end
end
