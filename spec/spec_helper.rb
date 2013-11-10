require 'active_resource'
require 'active_resource/http_mock'
require 'ostruct'

require 'prediction_io'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.before { stub_const('PredictionIO::CONFIG_PATH', File.expand_path("../support", __FILE__)) }
end
