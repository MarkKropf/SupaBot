require 'em-irc'

module Supabot
  class Irc
    include Connector

    def run 
      @client = EventMachine::IRC::Client.new do |c|
        c.host @opts[:host]
        c.port @opts[:port]
        c.logger @robot.logger

        c.on :connect do
          c.nick @robot.name         
          EM.add_timer(5) { 
            @opts[:channels].each do |chan|
              c.join chan
            end    
          }
        end

        c.on :message do |source, target, message|
          message = IrcTextMessage.new(message, source, self, target)
          receive message
        end
      end
      @client.connect      
    end

    def send(response)
      if response.text.respond_to? :lines
        response.text.lines do |line|
          @client.message response.message.send_to, line
        end                           
      else
        @client.message response.message.send_to, response.text  
      end              
    end
    
    private
    
    class IrcTextMessage < TextMessage
      attr_accessor :send_to
      
      def initialize(text, user, connector, target)
        super text, user, connector
        @send_to = target.start_with?('#') ? target : user 
      end
    end

  end
end