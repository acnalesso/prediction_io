module PredictionIO

  class Server < ::ActiveResource::Base

    self.site = PredictionIO::HOST

    ##
    # Gets default site url set at Server
    # then substitutes http for https
    #
    def self.set_https!
     self.site = self.site.to_s.sub!("http", "https")
    end

  end

  class Connection < Server
    ##
    # TODO:
    # Add support to ssl authentications
    #
  end

  class User < Connection

    ##
    # Changes http to https
    #
    self.set_https!

    self.user     = PredictionIO::USERNAME
    self.password = PredictionIO::PASSWORD

    def self.create_user(user_id, args={})
      self.create({ user: { user_id: user_id }.merge(args) })
    end

  end

end
