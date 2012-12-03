require 'eventmachine'

module Supabot
  class TestConnector
    include Connector

    def run
      @robot.hear(/hello/) do |thing|
        puts 'hi bro!'
      end
      
      receive 'hello'
      receive 'what are the three rules'
            
    end
    
    def send message
      puts message
    end
      
      
  end
end