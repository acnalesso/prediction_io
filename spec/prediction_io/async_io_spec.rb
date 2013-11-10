require 'spec_helper'
require 'prediction_io/async_io'

PredictionIO::AsyncIO.class_eval do
  ##
  # Returns queue's size and pops one
  # item from queue.
  def extract_size!
    queue.size.tap { queue.pop }
  end
end

describe PredictionIO::AsyncIO do

  before { Thread.stub(:new).and_return(double) }

  let(:alien) { PredictionIO::AsyncIO.new }

  context "initialising" do
    it "should have a queue" do
      alien.queue.should be_kind_of Queue
    end

    it "should create 1 thread as default" do
      alien.threads.size.should eq(1)
    end

    it "should have 5s default time to live" do
      alien.ttl.should eq(5)
    end
  end

  context "#worker" do

    it "should have a worker method" do
      alien.should respond_to :worker
    end

    it "should_not raise_error when no block is passed" do
      expect {
        alien.worker(:jason)
      }.to_not raise_error
    end

    it "should not raise error when block is passed" do
      expect {
        alien.worker(:lizza) { }
      }.to_not raise_error
    end

    it "should push worker onto the queue" do
      alien.worker(:paul) { }
      alien.extract_size!.should eq(1)
    end

    it "should return an instance of Worker" do
      result = alien.worker(:blunt) { }
      result.should be_instance_of PredictionIO::AsyncIO::Worker
    end
  end


  context "#rescuer" do
    it { alien.should respond_to :rescuer }

    it "should rescue when an exception is raised" do
      expect {
        alien.rescuer { raise "hell" }
      }.to_not raise_error
    end

    it "should not raise when no block" do
      expect {
        alien.rescuer
      }.to_not raise_error
    end

    it "should not raise when block is present" do
      expect {
        alien.rescuer { :imma_block }
      }.to_not raise_error
    end
  end

  context "#timeout" do
    before { alien.stub(:ttl).and_return(0.00001) }

    it "should not raise error if time exceeded" do
      expect {
        alien.timer { sleep(0.001) }
      }.to_not raise_error
    end

    it "should suspend operation if time is exceeded" do
      alien.timer { sleep(1) }.should be_nil
    end

  end

  context "#async" do
    it { alien.should respond_to :async }

    ##
    # NOTE: this snippet here can be a little tricky
    # First we create a lambda ( -> its just Ruby syntatic sugar )
    # Second we create a double ( a mock )
    # Third we stub out the state of our original
    # method and return the double
    #
    # Then we call the method +async+ which takes a block to be
    # 'passed' an object.
    #
    # Last but not least we check if our object has received
    # that message with that particular argument.
    #
    # Ruby allows us to do some cool stuff with coercion and
    # closures while using blocks.
    # The following might be helpul:
    # robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas

    #
    it "should pass this payload block onto Worker" do
      payload = -> { :im_an_async_job }

      worker = double
      alien.stub(:worker).
        and_return(worker)

      ##
      # See the link below for a better understading how to
      # pass/call blocks of code in Ruby.
      # pragdave.pragprog.com/pragdave/2005/11/symbolto_proc.html
      #
      alien.async(&payload) # to_proc

      alien.should have_received(:worker).with(payload)
    end
  end

  context "#consumer" do
    it { alien.should respond_to :consumer }

    it "should pop and consume items in a queue" do
      bob = double

      ##
      # returns false to break the while loop.
      #
      bob.should_receive(:pop).and_return(false)
      alien.stub(:queue).and_return(bob)

      alien.consumer.should be_nil
    end

    it "should not raise any error" do
      tob = -> { raise "Not going to be Raised" }
      alien.queue.push(tob)

      expect {
      alien.consumer
      }.to_not raise_error
    end

    it "should call a worker" do
      duck = double
      duck.should_receive(:call)

      alien.stub(:queue).and_return([duck])

      alien.consumer
    end

  end

end
