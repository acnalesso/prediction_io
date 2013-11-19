require 'prediction_io/connection'

module PredictionIO
  class User < Connection

    ##
    # Changes http to https
    #
    self.set_https!

    self.user     = PredictionIO::USERNAME
    self.password = PredictionIO::PASSWORD


    def self.acreate_user(uid, params={}, &payload)
      PredictionIO.async(payload) do
        params = { pio_uid: uid }.merge!(params)
        User.create(params)
      end
    end

  end
end
