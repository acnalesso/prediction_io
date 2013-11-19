module ActiveResource
  class Base
    def self.method_missing(name, *args)
      self.send(:define_singleton_method, :name) { args }
    end
  end

end

require 'spec_helper'
require 'prediction_io'

describe PredictionIO do
  let(:fake_async) { PredictionIO::FakeAsync.new }
  let(:pio) { PredictionIO }
  let(:payload) { ->(n) { n } }

  it "should have created async object" do
    PredictionIO::AsyncIO.should_receive(:new).
      with(PredictionIO::POOL)

    pio.async_creator
  end

  it "should be able to change async object" do
    pio.async_creator = fake_async
    pio.async_creator.should eq(fake_async)
  end

  context ".async" do
    it { pio.should respond_to :async }

    it "should create async jobs" do
      fake_async.should_receive(:worker).with(:payload)
      pio.stub(:async_creator).and_return(fake_async)

      pio.async(:payload) { :job }
    end

    it "should raise error if no payload is given" do
      expect {
        pio.async
      }.to raise_error
    end

    it "should raise error when payload does not respond to call" do
      expect {
        pio.async(:payload)
      }.to raise_error
    end

    it "should not raise error when payload responds to call" do
      payload = Object.new
      def payload.call(n); n; end

      expect {
        pio.async(payload) { }
      }.to_not raise_error
    end

  end

end
