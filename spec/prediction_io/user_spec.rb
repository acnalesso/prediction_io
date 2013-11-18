require 'ostruct'
require 'spec_helper'
require 'active_resource'
require 'prediction_io/user'

module PredictionIO
describe User do

  let(:user)    { User }
  let(:config)  { Configurator }

  context "Configuration" do
    it "should have site host" do
      user.site.to_s.should match /localhost/
    end

    it "should connect via https" do
      user.site.to_s.should match /https:/
    end

    it "should only set https to user object" do
      Server.site.to_s.should_not match /https:/
    end

    it "should have password" do
      # eq("my_secret_key")
      user.password.should eq(PASSWORD)
    end

    it "should have an username" do
      # eq('batman')
      user.user.should eq(USERNAME)
    end
  end

  context "Creating an user" do
    it { user.should respond_to :create_user }

    it "should pass user id to be created" do
      params = { user: { user_id: 1 } }
      user.stub(:create).with(params).and_return(true)
      user.create_user(1).should be_true
    end
  end

end
end
