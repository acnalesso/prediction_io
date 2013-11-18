module PredictionIO
  CONFIG_PATH = File.
    expand_path("../support", __FILE__)
end

require 'active_resource/http_mock'
require 'prediction_io/configurator'
require 'prediction_io/logger'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

RSpec::Matchers.define(:be_rescued){ |e|
  match { |a| a === :rescued }
}
