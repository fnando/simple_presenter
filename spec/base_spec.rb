require "spec_helper"

describe SimplePresenter::Base do
  describe ".expose" do
    context "not using :with option" do
      subject { UserPresenter.new }

      it { should respond_to(:name) }
      it { should respond_to(:email) }
      it { should_not respond_to(:password_hash) }
      it { should_not respond_to(:password_salt) }
    end

    context "using :with option" do
      subject { CommentPresenter.new }

      it { should respond_to(:user_name) }
    end
  end

  describe ".subjects" do
    it "is aliased as .subject" do
      thing = mock("Thing")
      presenter_class = Class.new(Presenter)
      presenter_class.subject :thing
      presenter = presenter_class.new(thing)

      presenter.instance_variable_get("@thing").should eql(thing)
    end

    context "using defaults" do
      let(:user) { stub :name => "John Doe", :email => "john@doe.com" }
      subject { UserPresenter.new(user) }

      its(:name) { should == "John Doe" }
      its(:email) { should == "john@doe.com" }
    end

    context "specifying several subjects" do
      let(:user) { stub :name => "John Doe" }
      let(:comment) { stub :body => "Some comment", :user => user }
      let(:post) { stub :title => "Some post" }
      subject { CommentPresenter.new(comment, post) }

      its(:body) { should == "Some comment" }
      its(:post_title) { should == "Some post" }
      its(:user_name) { should == "John Doe" }
    end

    context "when subjects are nil" do
      let(:comment) { stub :body => "Some comment" }
      subject { CommentPresenter.new(comment, nil) }

      its(:post_title) { should be_nil }
    end
  end

  describe ".map" do
    context "wraps a single subject" do
      let(:user) { stub :name => "John Doe" }
      subject { UserPresenter.map([user])[0] }

      it { should be_a(UserPresenter) }
      its(:name) { should == "John Doe" }
    end

    context "wraps several subjects" do
      let(:comment) { stub :body => "Some comment" }
      let(:post) { stub :title => "Some post" }
      let(:user) { stub :name => "John Doe" }
      subject { CommentPresenter.map([comment], post)[0] }

      it { should be_a(CommentPresenter) }
      its(:body) { should == "Some comment" }
      its(:post_title) { should == "Some post" }
    end
  end

  describe "#initialize" do
    let(:user) { mock }
    subject { UserPresenter.new(user) }

    it "assigns the subject" do
      subject.instance_variable_get("@subject").should == user
    end
  end
end
