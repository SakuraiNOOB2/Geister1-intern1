module GeisterProtocol
  module Schema
    class Link
      def initialize(link_schema)
        @schema = link_schema
      end

      def request
        @request ||= Request.new(@schema)
      end

      def response
        @response ||= Response.new(@schema)
      end

      def name
        @schema[:title]
      end
    end
  end
end
