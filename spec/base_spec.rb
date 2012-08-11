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

    context "exposing iterators" do
      subject { IteratorPresenter.new([1, 2, 3]) }

      its(:each) { should be_a(Enumerator) }

      it "uses provided block" do
        numbers = []
        subject.each {|n| numbers << n}
        expect(numbers).to eql([1, 2, 3])
      end
    end
  end

  describe ".attributes" do
    context "using defaults" do
      let(:presenter) { UserPresenter }
      subject { presenter.attributes }

      it { should have(2).items }
      its([:name]) { should eql([:name, {}]) }
      its([:email]) { should eql([:email, {}]) }
    end

    context "using provided options" do
      let(:presenter) { CommentPresenter }
      subject { presenter.attributes }

      it { should have(3).items }
      its([:user_name]) { should eql([:name, {with: :user}]) }
      its([:post_title]) { should eql([:title, {with: :post}]) }
    end
  end

  describe ".subjects" do
    it "is aliased as .subject" do
      thing = mock("Thing")
      presenter_class = Class.new(Presenter)
      presenter_class.subject :thing
      presenter = presenter_class.new(thing)

      expect(presenter.instance_variable_get("@thing")).to eql(thing)
    end

    context "using defaults" do
      let(:user) { stub :name => "John Doe", :email => "john@doe.com" }
      subject { UserPresenter.new(user) }

      its(:name) { should == "John Doe" }
      its(:email) { should == "john@doe.com" }

      it "responds to private subject method" do
        expect(subject.private_methods).to include(:subject)
      end

      it "returns subject" do
        expect(subject.send(:subject)).to eql(user)
      end
    end

    context "specifying several subjects" do
      let(:user) { stub :name => "John Doe" }
      let(:comment) { stub :body => "Some comment", :user => user }
      let(:post) { stub :title => "Some post" }
      subject { CommentPresenter.new(comment, post) }

      its(:body) { should == "Some comment" }
      its(:post_title) { should == "Some post" }
      its(:user_name) { should == "John Doe" }

      it "responds to private comment method" do
        expect(subject.private_methods).to include(:comment)
      end

      it "responds to private post method" do
        expect(subject.private_methods).to include(:post)
      end

      it "returns comment subject" do
        expect(subject.send(:comment)).to eql(comment)
      end

      it "returns post subject" do
        expect(subject.send(:post)).to eql(post)
      end
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
      expect(subject.instance_variable_get("@subject")).to eql(user)
    end
  end

  describe "inherited presenter" do
    let(:presenter) { Class.new(CommentPresenter) }

    context "subjects" do
      subject { presenter.subjects }

      specify { expect(subject).to have(2).items }
      specify { expect(subject.first).to eql(:comment) }
      specify { expect(subject.last).to eql(:post) }
    end

    context "attributes" do
      subject { presenter.attributes }

      it { should have(3).items }
      its([:user_name]) { should eql([:name, {with: :user}]) }
      its([:post_title]) { should eql([:title, {with: :post}]) }
    end
  end
end
