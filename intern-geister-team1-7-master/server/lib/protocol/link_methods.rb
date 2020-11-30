module Protocol
  module LinkMethods
    extend ActiveSupport::Concern

    module ClassMethods
      SUPPORTED_ACTIONS = {
        show: {
          method: 'GET',
          rel: 'self'
        },
        index: {
          method: 'GET',
          rel: 'self'
        },
        create: {
          method: 'POST',
          rel: 'create'
        },
        update: {
          method: 'PUT',
          rel: 'self'
        },
        destroy: {
          method: 'DELETE',
          rel: 'self'
        }
      }.freeze

      def link(action_name, options)
        default_options = SUPPORTED_ACTIONS[action_name] || {}
        link_name = "#{action_name}_#{title}"
        link_name = link_name.pluralize if action_name == :index

        super(link_name, default_options.merge(options))
      end
    end
  end
end
