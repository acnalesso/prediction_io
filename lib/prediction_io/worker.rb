require 'timeout'
require 'prediction_io/rescuer'

module PredictionIO
  class Worker
    include PredictionIO::Rescuer

    attr_reader :payload, :job
    attr_reader :finished, :done

    def initialize(payload, job)
      @payload  = payload
      @job      = job
      @done     = false
      @finished = false
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
    # need its result to be available within a block without
    # needing to wait for it to finish and non blocking IO.
    #
    # A payload is a Ruby object must pass, for example:
    #
    # payload = lambda { |u| print u.name }
    # payload = Object.new
    # def payload.call(result); warn(result); end
    #
    # job is pre-definied inside a method, it can
    # be anything, for example:
    # worker(payload) do
    #   User.find(uid)
    # end
    #
    def call
      try do
        @finished = true
        @done = job.call
        payload.call(done)
      end
    end

    ##
    # Tries to get the first job done, when an exception
    # is raised it then calls payload again passing an
    # fallback as its argument.
    #
    def try
      begin
        yield
      rescue Exception => notice
        rescuer { payload.call(fallback(notice)) }
      end
    end

    private

      ##
      # Instances of OpenStruct returns nil when the method
      # called does not exist. This prevents another exception
      # from being raised.
      # It returns an instance of OpenStruct object with the
      # exception rescued ( i.e notice ) and the worker that
      # was assigned to this particular job.
      #
      def fallback(notice)
        OpenStruct.new({ notice: notice, worker: self })
      end

  end
end
