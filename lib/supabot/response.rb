module Supabot
  class Response
    
    attr_accessor :message, :text
    
    def initialize(robot, message, match)
      @robot   = robot
      @message = message
      @match   = match      
    end
    
    def send(text)
      @text = text
      @message.connector.send self
    end
    
  end
end