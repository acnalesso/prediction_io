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
      Connection.site.to_s.should_not match /https:/
    end

    it "should have password" do
      #                    eq("my_secret_key")
      user.password.should eq(PASSWORD)
    end

    it "should have an username" do
      #                eq('batman')
      user.user.should eq(USERNAME)
    end
  end

  before do
    User.stub(:pio).
      and_return(PredictionIO::FakeAsync)
  end

  context "#acreate" do

    let(:params) { { pio_uid: 1 } }
    before { user.stub(:create).with(params).and_return(true) }

    it "should take an user_id to be created" do
      user.acreate(1).should be_true
    end

    it "should take extra params" do
      extra = { pio_latitude: 0.0, pio_longitude: 0.2 }
      params.merge!(extra)

      user.acreate(1, extra).should be_true
    end

  end

  context "#aget" do
    let(:get_params) { { pio_uid: 1, pio_appkey: "key" } }
    before { user.stub(:get).with(1, get_params).and_return(true) }

    it { user.should respond_to :aget }

    it "should aget one user" do
      user.aget(1, get_params).should be_true
    end

  end

end
end
