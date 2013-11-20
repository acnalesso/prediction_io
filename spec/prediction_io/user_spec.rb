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

      # TODO?
      # it "should connect via https" do
      #  user.site.to_s.should match /https:/
      # end

      it "should have password" do
        #                    eq("my_secret_key")
        user.password.should eq(PASSWORD)
      end

      it "should have an username" do
        #                eq('batman')
        user.user.should eq(USERNAME)
      end

      # 5 seconds as default
      it "should have timeout" do
        user.timeout.should eq(TIMEOUT)
      end

      context ".merge_params" do
        let(:master) { user.merge_params(1, { extra: :here }) }

        it "should have pio_appkey already set" do
          master[:pio_appkey].should eq(APPKEY)
        end

        it "should have pio_uid" do
          master[:pio_uid].should eq(1)
        end

        it "should have extra" do
          master[:extra].should eq(:here)
        end
      end

    end

    ##
    # This methods are tested in spec/prediction_io/async_methods_spec.rb
    # and on cucumber, therefore we do not need to overtest them here.
    #
    context "async methods" do
      %w{ get create delete }.each do |m|
        method = "a#{m}"

        it { user.should respond_to method }
      end
    end

  end
end
