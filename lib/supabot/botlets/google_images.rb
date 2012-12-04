require 'em-synchrony'
require 'em-synchrony/em-http'
require 'json'

module Supabot
  class GoogleImagesBotlet
    include Botlet

    def load
      @robot.respond /(image|img)( me)? (.*)/i do |response|
        EM.synchrony do                           
          response.send get_image(response.match[3])
        end
      end
    end

    def get_image(query)
      q = { :v => "1.0", :rsz => "8", :q => query, :safe => "active" }

      resp = EM::Synchrony.sync EventMachine::HttpRequest.
        new("http://ajax.googleapis.com/ajax/services/search/images").
        get(:query => q)

      images = JSON.parse(resp.response)
      images = images['responseData']['results']        
       
      images.length > 0 ? images.sample['unescapedUrl'] : '' 
    end

  end
end