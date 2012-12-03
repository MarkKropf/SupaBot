module Supabot
  class Response
    
    attr_accessor :text
    
    def initialize(robot, message)
      @robot = robot
      @text = message
    end
    
    def send(text)
      @robot.send text
    end
    
  end
end