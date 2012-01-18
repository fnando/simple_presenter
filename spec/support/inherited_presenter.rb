class PersonPresenter < SimplePresenter::Base
  subject :person
  attr_reader :person
end

class GamerPresenter < PersonPresenter
end
