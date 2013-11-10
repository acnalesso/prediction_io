require 'spec_helper'

module PredictionIO
  describe AsyncIO::Worker do

    let(:payload) { ->(r) { r } }
    let(:job)     { -> { :am_a_dog } }
    let(:worker) { AsyncIO::Worker.new(payload, job) }

    context "initialise" do

      it "must take a payload" do
        worker.payload.should be_kind_of Proc
      end

      it "must take a job" do
        worker.job.should be_kind_of Proc
      end
    end

    it { worker.should respond_to :done }

    it "should not be done as job is not finished" do
      worker.done.should be_false
    end

    it "must call payload and pass job as its argument" do
      worker.call.should eq(:am_a_dog)
    end

    context "Getting a job done" do
      it "should set done to its last finished job" do
        tesco = AsyncIO::Worker.new(payload, job)
        tesco.call
        tesco.done.should eq(:am_a_dog)
      end
    end
  end
end
