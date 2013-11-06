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
    # Default number of threads to be spawned is 1.
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
    # Yields data passed onto the queue to the passed block.
    #
    # NOTE: It suspends the calling thread until
    # data is pushed onto the queue, If non_block is true,
    # queue.shift(true) the thread isn't suspended and an
    # exception is raised.
    #
    # This is a FIFO(First in First Out) queue's data stack
    # http://en.wikipedia.org/wiki/FIFO
    #
    def consume
      while argument = queue.shift
        block.call(argument)
        mutex.synchronize { @off = queue.empty? }
      end
    end

    ##
    # Pushes data on to queue.
    # sets off to false which means
    # #finished? is not finished yet.
    #
    def push(*data)
      mutex.synchronize { @off = false }
      queue.push(*data)
    end

    ##
    # 'Waits' for threads to finish returns nil
    # if limit seconds have past or returns threads
    # themselves if threads where finished whithin limit seconds.
    #
    # If you call it without a limit second,
    # it will use 0.01s as default
    # Wait for a thread means:
    # Stops main thread ( current one ) and waits until the
    # other thread(s) is finished, then passes execution
    # to main thread again. )
    #
    # ttw = time_to_wait
    #
    def wait_threads_to_finish!(ttw=0.01)
      threads.map { |t| t.join(ttw) }
    end

    def finished?
      off
    end

    private(:off, :consume)

  end
end
