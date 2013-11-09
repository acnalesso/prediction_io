require 'spec_helper'
require 'prediction_io/configurator'

describe PredictionIO::Configurator do

  let(:config) { PredictionIO::Configurator }

  it "should have config file path" do
    config.config_file_path.should match /config\/prediction_io.yml/
  end

  it "should convert yaml to hash object" do
    config.yaml_to_hash.should be_true
  end

  it "should have an username" do
    config.user["username"].should eq "batman"
  end

  it "should have a password" do
    config.user["password"].should eq "secret"
  end

  it "should have a timeout" do
    config.request["timeout"].should eq(5)
  end

  it "should have a proxy" do
    config.server["proxy"].should be_nil
  end

  it "should have a logger_path" do
    config.logger_path.should be_nil
  end

end
