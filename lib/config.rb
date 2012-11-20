module Supabot

  #
  # routines for storing config information for the bot
  module Config  
    attr_accessor :config
    
    #
    # the entire config for the bot, loaded from YAML files and the DB if applicable
    def config
      @config ||= load_config
    end   

    #
    # has the config been loaded yet?
    def has_config?
      ! @config.nil?
    end

    #
    # Check to see if Sequel was loaded successfully.  If not, we won't make any DB calls
    def has_sequel?
      ! defined?(Sequel).nil?
    end
  end
end