module GeisterProtocol
  module Schema
    module Naming
      def initialize(link_schema)
        @schema = link_schema
      end

      def action
        @action = @schema[:title].split('_').first.inquiry
      end

      def action_name
        @action_name ||= begin
          case action
          when 'index'   then 'list'
          when 'destroy' then 'delete'
          when 'create'  then 'create'
          when 'show'    then 'show'
          when 'update'  then 'update'
          else action
          end
        end
      end

      def resource_name
        @resource_name ||= begin
          resource_name = @schema[:title].split('_')[1..-1].join('_')
          action.index? ? resource_name.pluralize : resource_name.singularize
        end
      end

      def to_s
        self.class.name.split('::').last + action_name.camelize + resource_name.camelize
      end
    end
  end
end
