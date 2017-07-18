module DayliteClient
  module Middleware
    class Authentication < Faraday::Middleware
      def call(env)
        env[:request_headers]["Authorization"] = "Bearer #{DayliteClient::Client.instance.api_key}"
        @app.call(env)
      end
    end
  end
end
