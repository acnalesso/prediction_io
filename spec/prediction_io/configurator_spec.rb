require 'spec_helper'

describe PredictionIO::Configurator do
  subject { described_class }

  context "internals" do
    its(:config_file_path) { should match(/config\/prediction_io.yml/) }
    its(:yaml_to_hash)     { should be_true }
  end

  context "configuration" do
    it "should have a username" do
      PredictionIO::USERNAME.should eq("batman")
    end

    it "should have a password" do
      PredictionIO::PASSWORD.should eq("secret")
    end

    it "should have a timeout" do
      PredictionIO::TIMEOUT.should eq(5)
    end

    it "should have a proxy" do
      PredictionIO::PROXY.should be_nil
    end

  end

end
