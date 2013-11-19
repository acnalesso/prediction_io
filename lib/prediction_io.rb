require 'prediction_io/load'

module PredictionIO

  def self.async_creator=(new_async)
    @@async_creator = new_async
  end

  def self.async_creator
    @@async_creator ||= AsyncIO.new(POOL)
  end

  ##
  # Creates async jobs, if a job (i.e ruby block)
  # is not given it passes an empty job to woker.
  # That allows us to do:
  #
  # payload = ->(n) { sleep(10); print n }
  # async(payload)
  #
  def self.async(payload, &job)
    job = block_given? ? job : lambda {}
    async_creator.worker(payload, &job)
  end

end
