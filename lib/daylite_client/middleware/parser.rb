module DayliteClient
  module Middleware
    class Parser < Faraday::Response::Middleware

      def on_complete(env)
        # errors processing since shitty daylite api
        # returns html instead of json in a case when api_key is outdated
        if unacceptable_codes.has_key?(env[:status])
          raise APIError.new(env[:status], unacceptable_codes[env[:status]])
        else
          original_json = MultiJson.load(env[:body])

          # daylite may return object or array(with objects or strings),
          # so we need to handle it and process only objects
          if original_json.is_a?(Array)
            json = {}

            # this complicated code generates different json[:data] values
            # it can be `[]` or `{ collection: [] }`
            # because Her gem throws an error when Contact.all is a hash with :collection key
            # but without this it throws an error for every resource, that's just array of strings (like Labels)
            original_json.each do |item|
              if item.is_a?(Hash)
                (json[:data] ||= []).push(item.deep_transform_keys{ |k| string_to_snakecase(k.to_s).to_sym })
              else
                json[:data] ||= {}
                (json[:data][:collection] ||= []).push(item)
              end
            end
          else
            json = original_json.deep_transform_keys{ |k| string_to_snakecase(k.to_s).to_sym }
            json = {
              data:   json.select { |k, _v| k != :error },
              errors: json.slice(:error)
            }
          end
        end

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
        # https://developer.marketcircle.com/v1/docs/http-status-codes-1
        {
          400 => 'Bad Request',
          401 => 'Unauthorized',
          403 => 'Forbidden',
          404 => 'Not Found',
          406 => 'Not Acceptable',
          429 => 'Too Many Requests',
          500 => 'Internal Server Error',
          503 => 'Service Unavailable',
        }
      end
    end
  end
end
