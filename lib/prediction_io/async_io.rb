require 'thread'
require 'timeout'

module PredictionIO
  class AsyncIO
    ##
    # Default:
    # Number of threads to be spanwed is 1
    # Time to live of a worker is 5 seconds
    #
    # NOTE: Any sort of exception raised while
    # 'getting' a job done will not be raised at all.
    # Instead it will be logged to a specified log file.
    #
    # Whenever an exception is raised a thread that the
    # exception was raised from is killed, so we need a
    # way to prevent threads from being killed. Therefore it
    # logs all rescues all exceptions raised and logs them.
    #
    attr_reader :ttl, :queue, :threads
    def initialize(n_threads=1)
      @queue    = Queue.new
      @ttl      = PredictionIO::TIMEOUT
      @threads  = []
      n_threads.times { @threads << Thread.new { consumer } }
    end

    def consumer
      rescuer do
        while worker = queue.pop
          timer { worker.call }
        end
      end
    end

    ##
    # Every worker must finish its job within a limit time
    # timer hre makes sure they do so.
    #
    def timer
      rescuer do
        Timeout.timeout(ttl) { yield }
      end
    end

    ##
    # It creates a new Worker a push it onto the queue,
    # whenever a 'job' (i.e a block of code ) is finished
    # it calls the payload and passes the result of job
    # to it.
    #
    # For example:
    #
    # def aget_user(uid, &payload)
    #   worker(payload) do
    #     User.find(ui)
    #   end
    # end
    #
    # It returns the worker created for a particular job
    # which you could send a message +job+ to it in order
    # to retrieve its job done.
    #
    # For example:
    # result = aget_user(1) { |u| Logger.info(u.name) }
    #
    # # job may take a while to be done...
    #
    # user = result.job
    # user.name
    # => "Testing"
    #
    # NOTE: When you use the snippet above, if the job
    # has not been finished yet you will get +nil+
    # whenever you send a message +job+ to it. Once
    # job is finished you will be able to get its result.
    #
    def worker(payload, &job)
      rescuer do
        Worker.new(payload, job).tap { |w|
          queue.push(w)
        }
      end
    end

    ##
    # Rescues any sort of exception raised and
    # log it to the default logger.
    #
    def rescuer
      begin
        yield
      rescue Exception => e
        # write to log files
      end
    end

    ##
    # Perform any sort of task that needs to be
    # asynchronously done.
    # NOTE: It does not return anything, as it receives
    # and empty job. ( i.e empty block of code )
    #
    def async(&payload)
      worker(payload) { }
    end

    class Worker
      attr_reader :payload, :job, :done

      def initialize(payload, job)
        @payload  = payload
        @job      = job
        @done     = false
      end

      ##
      # It sends payload a message +call+
      # and passes the result of a job, by sending
      # job a message +call+ as well, as its argument.
      # This allows us to do:
      #
      # aget_user(1) { |u| print u.name }
      #=> Paul Clark Manson
      #
      # Or any other sort of task that you may
      # need its result to be available within a block.
      #
      # payload is the block you pass, for example:
      # { |u| print u.name }
      #
      # job is pre-definied inside a method, it can
      # be anything, for example:
      # worker(payload) do
      #   User.find(uid)
      # end
      #
      def call
        @done = payload.call(job.call)
      end

    end

  end # AsyncIO
end
