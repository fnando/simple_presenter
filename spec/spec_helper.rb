require "bundler"
Bundler.setup(:default, :development)
Bundler.require

require "simple_presenter"

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each do |file|
  require file
end
