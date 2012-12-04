module Supabot
  class YoutubeBotlet
    include Botlet
    
    def load
      @robot.respond /(youtube|yt)( me)? (.*)/i do |response|
        EM.synchrony do
          
          q = { :orderBy => "relevance", 'max-results' => "15", :alt => 'json', :q => response.match[3] }
          
          resp = EM::Synchrony.sync EventMachine::HttpRequest.
            new("http://gdata.youtube.com/feeds/api/videos").
            get(:query => q)

          videos = JSON.parse(resp.response)
          videos = videos['feed']['entry']        

          video = videos.sample
          
          video['link'].each do |l|
            if l['rel'] == 'alternate' && l['type'] == 'text/html'
              response.send l['href'] 
            end
          end
                    
        end
      end
    end
    
  end
end