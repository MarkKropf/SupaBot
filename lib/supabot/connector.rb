module Supabot
  module Connector

   def initialize(robot, opts={})
     @robot = robot
     @opts  = opts
   end
   
   def send(message)
   end
   
   def receive(message)
     @robot.receive message
   end
    
  end
end