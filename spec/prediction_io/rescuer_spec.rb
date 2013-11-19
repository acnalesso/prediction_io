require 'spec_helper'
require 'prediction_io/rescuer.rb'

class Guard
  include PredictionIO::Rescuer

  def initialize
    @logger = PredictionIO::Logger
  end

end

describe PredictionIO::Rescuer do
  let(:logger) { PredictionIO::Logger }
  let(:guard) { Guard.new }

  it { guard.should respond_to :rescuer }

  context "#rescuer" do

    it "should rescue when an exception is raised" do
      expect {
        guard.rescuer { raise "hell" }
      }.to_not raise_error
    end

    it "should not raise when no block" do
      expect {
        guard.rescuer
      }.to_not raise_error
    end

    it "should not raise when block is present" do
      expect {
        guard.rescuer { :imma_block }
      }.to_not raise_error
    end
  end

  context "Logs", "whenever an exception is raised"  do

    it "should write error to logger" do
      guard.rescuer { raise "log me!" }
      logger.read.should match /log me!/
    end

  end
end

