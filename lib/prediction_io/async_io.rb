require 'thread'
require 'prediction_io/worker'

module PredictionIO
  class AsyncIO
    include PredictionIO::Rescuer

    ##
    # Default:
    # Number of threads to be spanwed is 1
    #
    # NOTE: Any sort of exception raised while
    # 'getting' a job done will not be raised at all.
    # Instead it will be logged to a specified log file.
    #
    # Whenever an exception is raised, the thread that the
    # exception was raised from is killed, so we need a
    # way to prevent threads from being killed. Therefore it
    # rescues all exceptions raised and logs them.
    #
    attr_reader   :queue, :threads
    attr_accessor :logger
    def initialize(n_threads=1)
      @logger   = PredictionIO.logger
      @queue    = Queue.new
      @threads  = []
      n_threads.times { @threads << Thread.new { consumer } }
    end

    ##
    # Ruby Queue#pop sets non_block to false.
    # It waits until data is pushed on to
    # the queue and then process it.
    #
    def consumer
      rescuer do
        while worker = queue.pop
          worker.call
        end
      end
    end
    private(:consumer)

    ##
    # It creates a new Worker a push it onto the queue,
    # whenever a 'job' (i.e a Ruby object ) is finished
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
    # which you could send message +done+ to it in order
    # to retrieve its job done.
    # see prediction_io/worker.rb
    #
    # For example:
    # result = aget_user(1) { |u| logger.info(u.name) }
    #
    # # job may take a while to be done...
    #
    # user = result.done
    # user.name
    # => "John"
    #
    # NOTE: Whenever you use the snippet above, if the job
    # has not been finished yet you will get +false+
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
    # Perform any sort of task that needs to be
    # asynchronously done.
    # NOTE: It does not return anything, as it receives
    # and empty job. ( i.e empty block of code )
    #
    def async(&payload)
      worker(payload) { }
    end

  end
end
