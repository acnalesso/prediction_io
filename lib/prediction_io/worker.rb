require 'timeout'
require 'prediction_io/rescuer'

module PredictionIO
  class Worker
    include PredictionIO::Rescuer

    attr_reader :payload, :job, :done, :ttl

    def initialize(payload, job)
      @payload  = payload
      @job      = job
      @done     = false
      @ttl      = PredictionIO::TIMEOUT
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
    # need its result to be available within a block
    # without blocking IO.
    #
    # payload is a block you must pass, for example:
    # payload = lambda { |u| print u.name }
    #
    # job is pre-definied inside a method, it can
    # be anything, for example:
    # worker(payload) do
    #   User.find(uid)
    # end
    #
    # Every worker must finish a job within a limit
    # time, if not an exception is raised, logged,
    # and job is finished.
    #
    def call
      timer { @done = payload.call(job.call) }
    end

    ##
    # Every worker must finish a job within a limit time.
    # timer makes sure they do so.
    #
    def timer
      rescuer do
        Timeout.timeout(ttl) { yield }
      end
    end

  end
end
