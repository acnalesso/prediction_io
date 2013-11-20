require 'prediction_io/connection'

module PredictionIO
  class User < Connection

    ##
    # Changes http to https
    # self.set_https!

    self.user     = PredictionIO::USERNAME
    self.password = PredictionIO::PASSWORD


    def self.acreate(uid, params={}, &payload)
      pio.async(payload) {
        params = { pio_uid: uid }.merge!(params)
        User.create(params)
      }
    end

    def self.aget(uid, params={}, &payload)
      pio.async(payload) {
        User.get(uid, params.merge({ pio_uid: uid }))
      }
    end

    def self.adelete(uid, params={}, &payload)
      pio.async(payload) {
        User.delete(uid, params.merge!({ pio_uid: uid }))
      }
    end

    def self.pio
      @@pio ||= PredictionIO
    end

  end
end
