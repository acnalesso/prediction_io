module PredictionIO

  module Rescuer

    attr_accessor :logger

    ##
    # Rescues any sort of exception raised and
    # log it to a default logger, returns :rescued
    # if any exception was raised.
    #
    def rescuer
      begin
        yield
      rescue Exception => notice
        logger.error("[:PredictionIO::AsyncIO:] - #{notice}\n")
        :rescued
      end
    end

  end

end
