require 'yaml'
require 'ostruct'

module PredictionIO
  ##
  # Sets CONFIG_PATH to default config dir
  # if it hasn't been set yet.
  #
  CONFIG_PATH ||= File.expand_path("../../../", __FILE__)

  class Configuration

    ##
    # Open up singleton class
    #
    class << self

      ##
      # Converts yaml to a new hash object
      #
      def yaml_to_hash
        ::YAML.load_file config_file_path
      end

      ##
      # CONFIG_PATH  should point to root_path
      # default is /config/prediction_io.yml which allows
      # us to use convention over configuration. ( ie RoR )
      #
      def config_file_path
        CONFIG_PATH + "/config/prediction_io.yml"
      end

      # Ruby extraordinary OpenStruct
      # allows us to create getter/setter methods
      # by passing a hash when creating it whose values
      # will be its method body, returning a new obect
      # containing those methods or returns nil if method
      # does not exist.
      #
      # hash = { user: { username: "batman" } }
      # op = OpenStruct.new(hash)
      # op.user
      #=> { username: "batman" }
      #
      # op.password
      #=> nil
      #
      def objectify
        OpenStruct.new(yaml_to_hash)
      end

      ##
      # Little Ruby magic added
      # If you have:
      # user:
      #   username: batman
      #
      # and you call PredictionIO::Configuration.username
      # method_missing will call objectify and username
      # will exist there.
      # returns nil if method does not exist.
      #
      def method_missing(name, *args)
        objectify.send(name, *args)
      end

    end

  end
end
