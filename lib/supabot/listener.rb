module Supabot

  module Listener
    def call(message)
      @callback.call Response.new(@robot, message) if listen_to? message
    end
  end
  
  class TextListener
    include Listener
    
    def initialize(robot, regex, callback)
      @robot = robot
      @regex = regex
      @callback = callback
    end                   
    
    def listen_to? message
      @regex.match(message) ? true : false
    end
  end
  
end