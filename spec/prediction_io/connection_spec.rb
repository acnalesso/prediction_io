require 'spec_helper'
require 'prediction_io/connection'

describe PredictionIO::Connection do
  let(:ceo) { PredictionIO::Connection }

  it "should have pio_appkey defined" do
    ceo.default_params[:pio_appkey].should eq(PredictionIO::APPKEY)
  end

end
