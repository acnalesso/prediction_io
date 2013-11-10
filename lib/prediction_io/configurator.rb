require 'yaml'
require 'ostruct'

module PredictionIO

  ##
  # Sets CONFIG_PATH to default config dir
  # if it has not been set yet.
  #
  CONFIG_PATH ||= File.expand_path("../../../", __FILE__)

  class Configurator

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

      def generate_constants!
        yield_config { |const_name, value|
          PredictionIO.const_set(const_name, value)
        }
      end

      private

        ##
        # TODO: Allow nested constants
        # {
        #   user { username: "ab", proxy: "...",
        #   api: { proxy: "..." }
        # }
        #
        # Should be USERNAME, USERNAME::PROXY
        #
        # OR
        # We could set constants based on the hash key,
        # for example:
        #
        # User.set_constant("USERNAME", "ab")
        # User.set_constant("PROXY", "ab")
        #
        # PredictionIO.set_const("PROXY", "..")
        #
        # They constant look up in Ruby works is that it first
        # looks for this constant in the first most object
        # in this case User or PredictionIO and it keeps going
        # up the constants stack until it finds it, otherwise
        # it raises an exception. ( Uninitialized Constant ... )
        #
        #
        #
        # Yields configuration ready to create constants
        # and set their values.
        #
        # { user: { username: "a", password: "b" } }
        #
        # USERNAME, "a"
        # PASSWORD, "b"
        #
        def yield_config
          yaml_to_hash.each_value do |config|
            config.each { |v| yield(v[0].upcase, v[1].freeze) }
          end
        end

    end

  end

  ##
  # Generates constants
  Configurator.generate_constants!

end
