module SimplePresenter
  module UrlMethods
    def default_url_options
      Rails.configuration.simple_presenter.default_url_options ||
      Rails.configuration.action_mailer.default_url_options ||
      {}
    end
  end
end
