require 'active_resource/http_mock'
require 'prediction_io/configurator'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

module PredictionIO
  PredictionIO::CONFIG_PATH = File.
    expand_path("../support", __FILE__)
end
