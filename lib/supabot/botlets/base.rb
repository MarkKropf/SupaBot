module Supabot
  class BaseBotlet
    include Botlet
    
    def load
      @robot.respond /time$/i do |response|
        response.send "Server time is: #{Time.now}"
      end
      
      @robot.respond /die$/i do |response|
        response.send "Peace out homeys"
        EM.next_tick { exit }
      end
    end
  end
end