require 'em-irc'

module Supabot
  class Irc
    include Connector

    def run 
      @robot.hear /^#{@robot.name}/i do |response|
        require 'ostruct'
        o = OpenStruct.new
        o.target = @opts[:channels].first
        o.text = 'What?'
        send o
      end

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
          receive message
        end
      end
      @client.connect      
    end

    def send message                               
      if message.respond_to?(:target)
        puts 'here'
        @client.message message.target, message.text 
      else
        message.lines do |line|
          @client.message '#test', line
        end
      end
      
    end



  end
end