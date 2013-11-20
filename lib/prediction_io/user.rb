require 'prediction_io/connection'

module PredictionIO
  class User < Connection

    ##
    # Changes http to https
    # self.set_https!

    self.user     = PredictionIO::USERNAME
    self.password = PredictionIO::PASSWORD


    def self.merge_params(id, params)
      { pio_uid: id }.merge!(default_params).merge!(params)
    end

  end
end
