require 'thread'
module PredictionIO
  class AsyncConsumer

    ##
    # Returns arguments passed on to the queue
    # For example:
    # @name = "Antonio C Nalesso"
    # @a ||= AnagramSolver::AsyncConsumer.new do |*args|
    #   sleep(1)
    #   print args.join(", ")
    # end
    #
    # @a.push([ "My name is", @name ])
    # print :Hurray
    # => Hurray
    # => My name is Antonio C Nalesso
    #
    # NOTE: There is a connascence of position
    # here, as @thread instance variable needs to
    # be the last assigned in order to work properly.
    #
    # Default number of threads to be spawn is 1.
    #
    attr_reader :block, :off
    attr_reader :queue, :threads, :mutex

    def initialize(spawn_threads=1, &block)
      @threads = []
      @queue  = Queue.new
      @mutex  = Mutex.new
      @off    = true
      @block  = block

      spawn_threads.times { @threads << Thread.new { consume } }
    end

    ##
    # Consumes queue's data ( call a block passed )
    # yielding its queue's data to it.
    #
    # This queue's data stack is a 
    # FIFO ( First In First Out ).
    # http://en.wikipedia.org/wiki/FIFO
    #
    def consume
      while arg = queue.shift
        mutex.synchronize do
          block.call(arg)
          @off = queue.empty?
        end
      end
    end

    ##
    # Pushes args in to queue.
    #
    def push(*args)
      queue.push(*args)
      mutex.synchronize { @off = false }
    end

    ##
    # 'Waits' for threads to finish returns nil
    # if limit seconds have past or returns threads
    # themselves if threads where finished whithin limit seconds.
    #
    # If you call it without a limit second,
    # it will use 0.001 ms as default
    # Wait for a threadmeans:
    # Stops main thread ( current one ) and waits until the
    # other thread(s) is finished, then passes execution
    # to main thread again. )
    #
    # ttw = time_to_wait
    #
    def wait_threads_to_finish!(ttw=0.001)
      threads.map { |t| t.join(ttw) }
    end

    def finished?
      off
    end

    private(:off, :consume)

  end
end
