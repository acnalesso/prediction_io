module PredictionIO
  CONFIG_PATH = File.
    expand_path("../support", __FILE__)
end

require 'prediction_io'
require 'prediction_io/configurator'

logger = Object.new
def logger.error(n); @n = n; end
def logger.read; @n; end
PredictionIO.configure_logger!(logger)

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

class PredictionIO::FakeAsync

  ##
  # Calls payload and passes whatever
  # job.call yields as its argument.
  #
  def self.async(payload, &job)
    payload = payload || ->(n) { n }
    payload.call(job.call)
  end

  def worker(payload, &job)
    payload.call(job.call)
  end

end

RSpec::Matchers.define(:be_rescued){ |e|
  match { |a| a === :rescued }
}
RSpec::Matchers.define(:be_deleted){ |e|
  match { |a| a === :deleted }
}
