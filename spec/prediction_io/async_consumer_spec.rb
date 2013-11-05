require 'spec_helper'
require 'prediction_io/async_consumer'

Thread.abort_on_exception = true

PredictionIO::AsyncConsumer.class_eval do
  ##
  # In order to facilitate tests
  # we have to define a few attr_writers
  # rather than be stubing an object all the time.
  #
  attr_writer :block

  public :consume, :off
end

describe PredictionIO::AsyncConsumer do
  let(:alien) { PredictionIO::AsyncConsumer.new { |d| d } }

  before { alien.wait_threads_to_finish! }

  it { alien.should respond_to :off }

  describe "Block" do
    it { alien.should respond_to :block }

    it "must yield content of block" do
      alien.block.call(:hiya).should eq(:hiya)
    end
  end

  describe "Queue" do
    it { alien.should respond_to :queue }
    it { alien.queue.should be_kind_of(Queue) }

    it "must push contents to queue" do
      alien.push("Test")
      alien.queue.size.should eq(1)
    end
  end

  describe "Thread" do
    it { alien.should respond_to :threads }

    it { alien.should respond_to :wait_threads_to_finish! }

    ##
    # NOTE:
    # Thread#join returns nil if limit seconds have past
    # in this case the thread is sleeping for 0.0001 and
    # we're not waiting at all. Therefore it returns nil
    #
    it "must not wait until thread is finished" do
      alien.stub(:threads).
        and_return( [ Thread.new { sleep 0.0001 } ] )
      alien.wait_threads_to_finish!(0).should eq([nil])
    end

    ##
    # Thread#join returns the thr if it's finished within
    # the limit seconds specified.
    #
    it "must accept time to wait" do
      alien.stub(:threads).
        and_return([ Thread.new { :im_finished! } ])

      alien.wait_threads_to_finish!.
          should eq(alien.threads)
    end
  end

  describe "Mutex" do
    it { alien.should respond_to :mutex }

    it { alien.mutex.should be_kind_of Mutex }

    it { alien.mutex.should respond_to :synchronize }
  end

  describe "Consuming" do

    it { alien.should respond_to :consume }

    ##
    # NOTE:
    # I could've used rspec stub, and stubed
    # out #block, or even passed it in while
    # initialising the object, but I wanted
    # to play around with ruby.
    #
    it "must consume data in queue" do
      alien.block = ->(*args) { }
      alien.push [ :test ]
      alien.wait_threads_to_finish!
      alien.queue.size.should eq(0)
    end

  end

  describe "#finished?" do
    it { alien.should respond_to :finished? }

    it "must be finished ('off') when initialised" do
      alien.finished?.should be_true
    end
  end

  context "Avoiding Race condition" do

    describe "Locking","with Mutex", :thread do

      it "must not be finished while pushing to queue" do
        alien.push(:im_going)
        alien.finished?.should be_false
      end

      it "must be finished when all consumed" do
        alien.push(:done)
        alien.wait_threads_to_finish!
        alien.finished?.should be_true
      end

      it "must return the same array value order" do
        a = []
        predator = PredictionIO::AsyncConsumer.new(5) { |d|
          a.push(d)
        }

        5.times { |j| predator.push(j) }
        predator.wait_threads_to_finish!
        a.should eq([0, 1, 2, 3, 4])
      end

    end
  end

end
