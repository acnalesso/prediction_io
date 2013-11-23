module PredictionIO
  ##
  # NOTE: The host class ( i.e included/extended this module )
  # must have method +merge_params(id, params) in order
  # to define parameters to be sent out.
  #
  module AsyncMethods

    def acreate(id, params={}, &payload)
      pio.async(payload) { self.create(merge_params(id, params)) }
    end

    ##
    # These methods need an id parameter.
    # Ruby Kernel#__callee__ gets the method name being called.
    # verb = :aget
    # ver[1..-1]
    #=> "get"
    #
    # aget(id, merge_params(id, params))
    #
    def amethod_with_id(id, params={}, &payload)
      verb = send(:__callee__)[1..-1]
      pio.async(payload) { self.send(verb, id, merge_params(id, params)) }
    end

    alias :aget :amethod_with_id
    alias :adelete :amethod_with_id

    def pio
      PredictionIO
    end

  end
end
