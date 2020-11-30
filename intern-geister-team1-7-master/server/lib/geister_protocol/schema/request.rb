module GeisterProtocol
  module Schema
    class Request
      include Naming

      def attributes
        @attributes ||= build_attributes_from_hash(params)
      end

      def href
        @href ||= @schema[:href]
      end

      def method
        @method ||= @schema[:method].inquiry
      end

      def to_apiclient_template(indent: 3, delimiter: "\t")
        strings = []

        strings << url_template
        strings << requester_method_template

        strings.map { |str| str.indent(indent, delimiter) }.join("\n")
      end

      def params
        @params ||= params_from_href.merge(params_from_properties)
      end

      private

      def params_from_href
        ids = @schema[:href].split('/').select { |path| path.gsub!(/\A:/, '') }.map(&:to_sym)
        ids.each_with_object({}) do |id, hash|
          hash[id] = { type: :integer, serialize: false }
        end
      end

      def params_from_properties
        # ex)
        # {:schema =>
        #   {:properties=>
        #     {:id=>
        #       {:description=>"unique identifier of user",
        #        :example=>1,
        #        :type=>"integer"},
        #      :name=>
        #       {:description=>"name of user",
        #        :example=>"alice",
        #        :type=>"string"}
        #     }
        #   }
        # }
        properties = (@schema[:schema] || {}).fetch(:properties, {})
        properties.each_with_object({}) do |(name, value), hash|
          hash[name] = begin
            if value[:properties]
              { type: value[:type].to_sym, items: value[:properties], serialize: true }
            else
              { type: value[:type].to_sym, serialize: true }
            end
          end
        end
      end

      def requester_method_template
        camelized_name = action_name.camelize + resource_name.camelize

        return "requester.Get<Response#{camelized_name}> (url, Response#{camelized_name});" if method.GET?

        request = "Request#{camelized_name}"
        response = "Response#{camelized_name}"

        "requester.#{method.downcase.camelize}<#{request},#{response}> (url, param, #{response});"
      end

      def url_template
        return %(var url = ipAddr + "#{href}";) unless params_from_href.present?

        url = href.dup
        attributes = build_attributes_from_hash(params_from_href)

        attributes.map(&:name).each_with_index { |v, idx| url.gsub!(/:#{v}/, "{#{idx}}") }

        params = attributes.map(&:name).map { |v| "param.#{v}" }

        %(var url = ipAddr + string.Format ("#{url}", #{params.join(', ')});)
      end

      def build_attributes_from_hash(hash)
        hash.map { |key, value| Attribute.new(key, value[:type], value[:items], value[:serialize]) }
      end
    end
  end
end
