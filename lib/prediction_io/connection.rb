module PredictionIO
  class Connection < ::ActiveResource::Base

    self.site     = PredictionIO::HOST
    self.timeout  = PredictionIO::TIMEOUT

    ##
    # Gets default site url set at Server
    # then substitutes http for https
    #
    def self.set_https!
     self.site = self.site.to_s.sub!("http", "https")
    end

    ##
    # TODO:
    # Add support to ssl authentications
    #
  end
end
