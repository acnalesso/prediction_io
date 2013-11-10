require 'spec_helper'
require 'prediction_io/configurator'

module PredictionIO
describe Configurator do

  let(:config) { PredictionIO::Configurator }

  context "internals" do
    it "should have config file path" do
      config.config_file_path.should match /config\/prediction_io.yml/
    end

    it "should convert yaml to hash object" do
      config.yaml_to_hash.should be_true
    end
  end

  context "configuration" do
    it "should have an username" do
      USERNAME.should eq("batman")
      # config.user["username"].should eq "batman"
    end

    it "should have a password" do
      PASSWORD.should eq("secret")
    end

    it "should have a timeout" do
      TIMEOUT.should eq(5)
    end

    it "should have a proxy" do
      PROXY.should be_nil
    end

  end

end
end
