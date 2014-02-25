require 'prediction_io/load'

module PredictionIO

  def self.logger
    @@logger ||= configure_logger!
  end

  def self.configure_logger!(logger=Logger.new(STDOUT))
    @@logger = logger
  end

  def self.async_creator=(new_async)
    @@async_creator = new_async
  end

  def self.async_creator
    @@async_creator ||= AsyncIO.new(POOL)
  end

  ##
  # Creates async jobs, if a payload (i.e ruby block)
  # is not given it passes an empty payload to woker.
  # That allows us to do:
  #
  # User.aget(1)
  # User.aget(1) { |u| print u.id }
  #
  # The response will be a worker that was created for this
  # particular job.
  #
  # NOTE: If you read PredictionIO::Worker you will see that
  # it calls payload and passes job as its arguments. This is
  # how it is available within a block later on.
  # NOTE: You must pass a job ( i.e ruby block ).
  #
  def self.async(payload, &job)
    payload = payload || ->(n) { n }
    async_creator.worker(payload, &job)
  end

end
