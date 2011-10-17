class User
  attr_accessor :name, :email, :password_salt, :password_hash

  def initialize(attrs = {})
    attrs.each {|name, value| __send__("#{name}=", value)}
  end
end
