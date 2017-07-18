module DayliteClient
  class Client
    API_URL = 'api.marketcircle.net'
    API_VERSION = 'v1'
    
    include Singleton
    
    attr_writer :api_key
    attr_reader :her_api
    
    def initialize
      init_her_api
    end

    def api_key
      Thread.current[:api_key] || ENV['DAYLITE_API_KEY']
    end
    
    def api_key=(value)
      Thread.current[:api_key] = value
    end

    def api_uri
      @api_uri ||= URI::HTTPS.build(host: API_URL, path: "/#{API_VERSION}")
    end
    
    private
    
    def init_her_api
      @her_api = Her::API.new
      @her_api.setup url: self.api_uri.to_s do |c|
        # Request
        c.use DayliteClient::Middleware::Authentication
        c.use Faraday::Request::UrlEncoded
      
        # Response
        c.use DayliteClient::Middleware::Parser
      
        # Adapter
        c.use Faraday::Adapter::NetHttp
      end
    end
  end
end
