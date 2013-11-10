require 'spec_helper'

describe PredictionIO::AsyncIO do
  subject { described_class.new }

  before do
    subject.stub(:extract_size!).and_return do
      subject.queue.size.tap { subject.queue.pop }
    end

    Thread.stub(:new).and_return(double)
  end

  context "initialising" do
    its(:queue)   { should be_kind_of(Queue) }
    its(:ttl)     { should eq(5) }

    context "default threads" do
      subject { described_class.new.threads }

      its(:size) { should eq(1) }
    end

  end

  context "#worker" do
    it { should respond_to(:worker) }

    it "should_not raise_error when no block is passed" do
      expect { subject.worker(:jason) }.to_not raise_error
    end

    it "should not raise error when block is passed" do
      expect { subject.worker(:lizza) { } }.to_not raise_error
    end

    it "should push worker onto the queue" do
      subject.worker(:paul) { }
      subject.extract_size!.should eq(1)
    end

    it "should return an instance of Worker" do
      worker = subject.worker(:blunt) { }
      worker.should be_instance_of(described_class::Worker)
    end
  end


  context "#rescuer" do
    it { should respond_to(:rescuer) }

    it "should rescue when an exception is raised" do
      expect { subject.rescuer { raise "hell" } }.to_not raise_error
    end

    it "should not raise when no block" do
      expect { subject.rescuer }.to_not raise_error
    end

    it "should not raise when block is present" do
      expect { subject.rescuer { :imma_block } }.to_not raise_error
    end
  end

  context "#timeout" do
    before { subject.stub(:ttl).and_return(0.00001) }

    it "should not raise error if time exceeded" do
      expect {
        subject.timer { sleep(0.001) }
      }.to_not raise_error
    end

    it "should suspend operation if time is exceeded" do
      subject.timer { sleep(1) }.should be_nil
    end

  end

  context "#async" do
    let(:worker)  { double }
    let(:payload) { proc { :im_an_async_job } }

    before do
      subject.stub(:worker).and_return(worker)
    end

    it { should respond_to(:async) }

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

    it "should pass this payload block onto Worker" do
      subject.should_receive(:worker).with(payload)
      subject.async(&payload) # to_proc
    end
  end

  context "#consumer" do
    let(:item) { double }
    let(:duck) { double }
    let(:tob) do
      proc { raise "Not going to be Raised" }
    end

    before do
      subject.stub(:queue).and_return([item])
    end

    it { should respond_to(:consumer) }

    context "with queue items that do not raise exceptions" do
      let(:item) { double }

      before do
        ##
        # returns false to break the while loop.
        #
        subject.queue.should_receive(:pop).and_return(false)
      end

      it "should pop and consume" do
        subject.consumer.should be_nil
      end
    end

    context "with queue items that raise an exception" do
      let(:item) do
        proc { raise "Not going to be raised" }
      end

      it "should not raise any error" do
        expect { subject.consumer }.to_not raise_error
      end
    end

    it "should call a worker" do
      item.should_receive(:call)

      subject.consumer
    end

  end

end
