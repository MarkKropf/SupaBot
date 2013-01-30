module Supabot

  module Listener
    def call(message)
      if match = @matcher.call(message)
        message.hear
        @callback.call Response.new(@robot, message, match)
      end
    end
  end

  class TextListener
    include Listener

    def initialize(robot, regex, callback)
      @robot = robot
      @regex = regex
      @callback = callback

      @matcher = lambda { |message| @regex.match(message.text) }
    end
  end

end