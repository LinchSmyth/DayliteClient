module DayliteClient
  module Middleware
    class Parser < Faraday::Response::Middleware

      def on_complete(env)
        # errors processing since shitty daylite api
        # returns html instead of json in a case of error
        if unacceptable_codes.has_key?(env[:status])
          return env[:body] =
            {
              data: {},
              errors: ["#{ env[:status] }: #{ unacceptable_codes[env[:status]] }"]
            }
        end

        original_json = MultiJson.load(env[:body])

        # daylite may return object or array(with objects or strings),
        # so we need to handle it and process only objects
        if original_json.is_a?(Array)
          json = original_json.map do |item|
            item.is_a?(Hash) ?
              item.deep_transform_keys{ |k| string_to_snakecase(k.to_s).to_sym } : item
          end
          json = { data: { collection: json } }
        else
          json = original_json.deep_transform_keys{ |k| string_to_snakecase(k.to_s).to_sym }
          json = {
            data:   json.select { |k, _v| k != :error },
            errors: json.slice(:error)
          }
        end

        binding.pry

        env[:body] = {
          data:   json[:data],
          errors: json[:errors]
        }
      end


      private


      def string_to_snakecase(string)
        string.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
              .gsub(/([a-z\d])([A-Z])/,'\1_\2')
              .tr('-', '_')
              .gsub(/\s/, '_')
              .gsub(/__+/, '_')
              .downcase
      end

      def unacceptable_codes
        {
          100 => 'Continue',
          101 => 'Switching Protocols',
          102 => 'Processing',
          # 200 => 'OK',
          # 201 => 'Created',
          # 202 => 'Accepted',
          203 => 'Non-Authoritative Information',
          204 => 'No Content',
          205 => 'Reset Content',
          206 => 'Partial Content',
          207 => 'Multi-Status',
          208 => 'Already Reported',
          226 => 'IM Used',
          300 => 'Multiple Choices',
          301 => 'Moved Permanently',
          # 302 => 'Found',
          303 => 'See Other',
          304 => 'Not Modified',
          305 => 'Use Proxy',
          307 => 'Temporary Redirect',
          308 => 'Permanent Redirect',
          400 => 'Bad Request',
          401 => 'Unauthorized',
          402 => 'Payment Required',
          403 => 'Forbidden',
          404 => 'Not Found',
          405 => 'Method Not Allowed',
          406 => 'Not Acceptable',
          407 => 'Proxy Authentication Required',
          408 => 'Request Timeout',
          409 => 'Conflict',
          410 => 'Gone',
          411 => 'Length Required',
          412 => 'Precondition Failed',
          413 => 'Payload Too Large',
          414 => 'URI Too Long',
          415 => 'Unsupported Media Type',
          416 => 'Range Not Satisfiable',
          417 => 'Expectation Failed',
          422 => 'Unprocessable Entity',
          423 => 'Locked',
          424 => 'Failed Dependency',
          426 => 'Upgrade Required',
          428 => 'Precondition Required',
          429 => 'Too Many Requests',
          431 => 'Request Header Fields Too Large',
          500 => 'Internal Server Error',
          501 => 'Not Implemented',
          502 => 'Bad Gateway',
          503 => 'Service Unavailable',
          504 => 'Gateway Timeout',
          505 => 'HTTP Version Not Supported',
          506 => 'Variant Also Negotiates',
          507 => 'Insufficient Storage',
          508 => 'Loop Detected',
          510 => 'Not Extended',
          511 => 'Network Authentication Required'
        }
      end
    end
  end
end
