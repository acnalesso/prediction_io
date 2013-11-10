require 'spec_helper'

describe PredictionIO::User do
  subject { described_class }

  context "Configuration" do
    context "site setup" do
      subject { described_class.site }

      its(:host)  { should eq('localhost') }
      its(:scheme) { should eq('https') }
    end

    its(:password) { should eq(PredictionIO::PASSWORD) }
    its(:user)     { should eq(PredictionIO::USERNAME) }

    it "should only set https to user object" do
      PredictionIO::Server.site.scheme.should_not eq('https')
    end

  end

  context "Creating an user" do
    let(:params) do
      { user: { user_id: 1 } }
    end

    before do
      subject.stub(:create).with(params).and_return(true)
    end

    it { should respond_to(:create_user) }

    it "should pass user id to be created" do
      subject.create_user(1).should be_true
    end
  end

end
