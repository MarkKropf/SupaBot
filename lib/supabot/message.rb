module Supabot

  module Message
    attr_accessor :user, :connector

    def initialize(user, connector)
      @user         = user
      @connector    = connector
      @done         = false
      @listen_count = 0
    end

    def finish
      @done = true
    end

    def hear
      @listen_count+=1
    end

    def ignored
      #override to provide functionality if no listeners acted on this message
    end

    def heard?
      @listen_count > 0
    end

    def unheard?
      !heard?
    end

    def done?
      @done
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