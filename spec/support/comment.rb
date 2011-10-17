class Comment
  attr_accessor :body, :created_at, :user

  def initialize(attrs = {})
    attrs.each {|name, value| __send__("#{name}=", value)}
  end
end
