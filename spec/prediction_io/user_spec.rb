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

  context "#acreate" do

    before do
      PredictionIO.should_receive(:async).
        and_return(true)
    end

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

end
end
