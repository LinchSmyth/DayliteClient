module DayliteClient
  module Middleware
    class DayliteAPIError < StandardError

      attr_reader :status, :message, :description

      def initialize(status = nil, description = "Unknown error")
        @status      = status
        @description = description
        @message     = "#{status.to_s + ': ' if status.present?}#{description}"
        super(@message)
      end

    end
  end
end
