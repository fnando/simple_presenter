module SimplePresenter
  autoload :Base, "simple_presenter/base"
  autoload :Version, "simple_presenter/version"

  require "simple_presenter/rails" if defined?(Rails)
end
