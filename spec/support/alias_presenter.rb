class AliasPresenter < Presenter
  expose :site
  expose :site, :as => :url
end
