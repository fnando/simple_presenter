module SimplePresenter
  class Base
    # Define how many subjects this presenter will receive.
    # Each subject will create a private method with the same name.
    #
    # The first subject name will be used as default, thus isn't required as <tt>:with</tt>
    # option on the SimplePresenter::Base.expose method.
    #
    #   class CommentPresenter < Presenter
    #     subjects :comment, :post
    #     expose :body                  # will expose comment.body through CommentPresenter#body
    #     expose :title, :with => :post # will expose post.title through CommentPresenter#post_title
    #   end
    #
    # Subjects can be accessed by a private name with the same name.
    # So the above subjects can be accessed internally by the methods +comment+ and +post+.
    #
    # If you're not setting any special name, then you can access it using the +subject+ method.
    #
    def self.subjects(*names)
      @subjects ||= [:subject]

      unless names.empty?
        @subjects = names
        attr_reader *names
        private *names
      end

      @subjects
    end

    class << self
      alias_method :subject, :subjects
    end

    # Propagate inherited subjects and attributes.
    #
    def self.inherited(child)
      child.subjects(*subjects)
      attributes.each_value do |attr_name, options|
        child.expose(attr_name, options)
      end
    end

    # Store all attributes and options that have been exposed.
    #
    #   class UserPresenter < Presenter
    #     expose :name
    #     expose :street, with: "address"
    #   end
    #
    #   UserPresenter.attributes
    #   #=> {
    #   #=>   name: [:name, {}],
    #   #=>   address_street: [:street, {with: "address"}]
    #   #=> }
    #
    def self.attributes
      @attributes ||= {}
    end

    # This method will return a presenter for each item of collection.
    #
    #   users = UserPresenter.map(User.all)
    #
    # If your presenter accepts more than one subject, you can provided
    # them as following parameters.
    #
    #   comments = CommentPresenter.map(post.comment.all, post)
    #
    def self.map(collection, *subjects)
      collection.map {|item| new(item, *subjects)}
    end

    # The list of attributes that will be exposed.
    #
    #   class UserPresenter < Presenter
    #     expose :name, :email
    #   end
    #
    # You can also expose an attribute from a composition.
    #
    #   class CommentPresenter < Presenter
    #     expose :body, :created_at
    #     expose :name, :with => :user
    #   end
    #
    # The presenter above will expose the methods +body+, +created_at+, and +user_name+.
    #
    def self.expose(*attrs)
      options = attrs.pop if attrs.last.kind_of?(Hash)
      options ||= {}

      attrs.each do |attr_name|
        subject = options.fetch(:with, nil)
        method_name = [subject, attr_name].compact.join("_")
        attributes[method_name.to_sym] = [attr_name, options]

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method_name}(&block)                                    # def user_name(&block)
            proxy_message(#{subject.inspect}, "#{attr_name}", &block)   #   proxy_message("user", "name")
          end                                                           # end
        RUBY
      end
    end

    # It assigns the subjects.
    #
    #   user = UserPresenter.new(User.first)
    #
    # You can assign several subjects if you want.
    #
    #   class CommentPresenter < Presenter
    #     subject :comment, :post
    #     expose :body
    #     expose :title, :with => :post
    #   end
    #
    #  comment = CommentPresenter.new(Comment.first, Post.first)
    #
    # If the :with option specified to one of the subjects, then the default subject is bypassed.
    # Otherwise, it will be proxied to the default subject.
    #
    def initialize(*subjects)
      self.class.subjects.each_with_index do |name, index|
        instance_variable_set("@#{name}", subjects[index])
      end
    end

    private
    def proxy_message(subject_name, method, &block)
      subject_name ||= self.class.subjects.first
      subject = instance_variable_get("@#{subject_name}")
      subject = instance_variable_get("@#{self.class.subjects.first}").__send__(subject_name) unless subject || self.class.subjects.include?(subject_name)
      subject.respond_to?(method) ? subject.__send__(method, &block) : nil
    end
  end
end
