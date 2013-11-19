require 'spec_helper'
require 'prediction_io/worker'

module PredictionIO
  Worker.class_eval do
    public(:fallback)
  end

  describe Worker do

    #              lambda { |r| r }
    let(:payload) { ->(r) { r } }
    let(:job)     { -> { :am_a_dog } }
    let(:worker)  { Worker.new(payload, job) }

    context "initialising" do

      it "must take a payload" do
        worker.payload.should be_kind_of Proc
      end

      it "must take a job" do
        worker.job.should be_kind_of Proc
      end

      it "should have set default for ttl" do
        worker.ttl.should eq 5
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
        worker.call
        worker.done.should eq(:am_a_dog)
      end
    end

    context "#timer" do
      before { worker.stub(:ttl).and_return(0.00001) }

      it { worker.should respond_to :timer }

      it "should raise error if time exceeded" do
        expect {
          worker.timer { sleep(0.001) }
        }.to raise_error
      end
    end

    describe "#try" do
      it { worker.should respond_to :try }

      context "failed" do
        it "should call fallback" do
          worker.should_receive(:fallback)
          worker.try { raise "failed" }
        end
      end

      context "success" do
        it "should not call fallback" do
          worker.should_not_receive(:fallback)
          worker.try { :happy }
        end
      end

      context "#fallback" do
        let(:fallback) { worker.fallback("notice") }

        it "should have a notice" do
          fallback.notice.should eq("notice")
        end

        it "should have a worker" do
          fallback.worker.should eq worker
        end

        it "should return nil when method not found" do
          fallback.will_return_nil.should be_nil
        end
      end

    end

  end
end
