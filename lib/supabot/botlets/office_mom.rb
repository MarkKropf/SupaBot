module Supabot
  class OfficeMomBotlet
    include Botlet

    def load
      @robot.respond /make me a pie/i do |response|
        response.send "Yes dear. Your office mom can't wait to bake for you!"
      end
    end
  end
end