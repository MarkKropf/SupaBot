#!/usr/bin/ruby -w

#
# the big kahuna!
module Supabot

  #
  # load in our assorted modules
  def self.load
    require "config"
    require "db"
    require "logging"
    require "base_connector"
    require "base_botlet"
    require "connectors/irc"
    require "connectors/twitter"
  end
end


# mount up
Supabot.load