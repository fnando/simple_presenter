class CommentPresenter < Presenter
  expose :body
  expose :name, :with => :user
  expose :title, :with => :post

  subjects :comment, :post
end
