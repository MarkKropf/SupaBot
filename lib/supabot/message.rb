module Supabot

  module Message
    attr_accessor :user, :connector, :done

    def initialize(user, connector)
      @user      = user
      @connector = connector
      @done      = false
    end
  end

  class TextMessage
    include Message

    attr_accessor :text

    def initialize(text, user, connector)
      super user, connector
      @text = text
    end
  end

end