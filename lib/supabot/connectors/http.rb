require 'evma_httpserver'

module Supabot
  class Http
    include Connector

    def run
      ip   = @opts[:ip] or '0.0.0.0'
      port = @opts[:port] or 8080

      EM.start_server ip, port, BotHttpServer, self
    end

    def send(response)
      response.message.http_response.content_type 'text/plain'
      response.message.http_response.status  = 200
      response.message.http_response.content = response.text
      response.message.http_response.send_response
    end

    class BotHttpServer < EM::Connection
      include EM::HttpServer

      def initialize(connector)
        @connector = connector
      end

      def post_init
        super
        no_environment_strings
      end

      def process_http_request
        # the http request details are available via the following instance variables:
        #   @http_protocol
        #   @http_request_method
        #   @http_cookie
        #   @http_if_none_match
        #   @http_content_type
        #   @http_path_info
        #   @http_request_uri
        #   @http_query_string
        #   @http_post_content
        #   @http_headers

        @connector.receive(HttpTextMessage.new(
          EM::DelegatedHttpResponse.new(self),
          @http_post_content,
          'httpuser',
          @connector,
          'notarget'))
      end
    end

    class HttpTextMessage < TextMessage
      attr_accessor :http_response

      def initialize(response, text, user, connector, target)
        super text, user, connector
        @http_response = response
      end
    end

  end
end