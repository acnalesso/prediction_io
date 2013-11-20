module PredictionIO
  ##
  # NOTE: The host class ( i.e included/extended this module )
  # must have method +merge_params(id, params) in order
  # to define parameters to be sent out.
  #
  module AsyncMethods

    def acreate(id, params={}, &payload)
      pio.async(payload) {
        self.create(merge_params(id, params))
      }
    end

    def aget(id, params={}, &payload)
      pio.async(payload) {
        self.get(id, merge_params(id, params))
      }
    end

    def adelete(id, params={}, &payload)
      pio.async(payload) {
        self.delete(id, merge_params(id, params))
      }
    end

    def pio
      PredictionIO
    end

  end
end
