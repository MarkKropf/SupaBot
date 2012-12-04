module Supabot
  class Shell
    include Connector

    def send(response)
      puts "#{@robot.name}> #{response.text}"
    end

    def run
      q = EM::Queue.new
      EM.open_keyboard(KeyboardHandler, q)
              
      print ">"

      cb = Proc.new do |msg|        
        receive TextMessage.new(msg, 'shell', self)
        print ">"
        q.pop &cb
      end
      q.pop &cb
    end

    class KeyboardHandler < EM::Connection
      include EM::Protocols::LineText2

      attr_reader :queue

      def initialize(q)
        @queue = q
      end

      def receive_line(data)
        @queue.push(data)
      end
    end
  end  
end