module JsonSchema
  class ScaffoldGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    class_option :skip_model, type: :boolean, default: false, desc: 'Skip generate model'
    class_option :skip_serializer, type: :boolean, default: false, desc: 'Skip generate serializer'
    class_option :skip_request_spec, type: :boolean, default: false, desc: 'Skip generate request_spec'
    class_option :skip_controller, type: :boolean, default: false, desc: 'Skip generate controller'

    def create_controller
      return if options[:skip_controller]
      actions = action_names(link_definitions).join(' ')

      generate 'controller', "#{plural_name.camelize} #{actions} --skip-routes -t rspec"
    end

    def add_route
      return if options[:skip_controller]
      actions = action_names(link_definitions).map { |name| ":#{name}" }.join(', ')

      route "resources :#{plural_name}, only: [#{actions}]" if actions.present?
    end

    def create_request_spec
      return if options[:skip_request_spec]
      template(
        'request_spec.rb.erb',
        Rails.root.join('spec', 'requests', "#{plural_name}_spec.rb"),
        links: link_definitions.map(&:as_json_schema)
      )
    end

    def create_serializer
      return if options[:skip_serializer]
      # NOTE: idはデフォルトで付加されるのでスキップする
      generate 'serializer', "#{name} #{property_names.reject { |item| item == :id }.join(' ')}"
      template(
        'serializer_spec.rb.erb',
        Rails.root.join('spec', 'serializers', "#{singular_name}_serializer_spec.rb")
      )
    end

    def create_model
      return if options[:skip_model]
      generate 'model', "#{singular_name} #{columns.join(' ')} -t rspec"
    end

    def annotate_models
      return if options[:skip_model]
      rake 'annotate_models'
    end

    private

    def schema_class
      @schema ||= ::GeisterProtocol.const_get(singular_name.camelize)
    end

    def link_definitions
      schema_class.link_definitions
    end

    def property_names
      schema_class.property_names
    end

    def columns
      schema_class.property_definitions.map do |property|
        # NOTE: id, created_at, updated_atはデフォルトで不可されるのでスキップする
        next if property.property_name.in? [:id, :created_at, :updated_at]

        schema = property.as_json_schema
        if schema[:format] == 'date-time'
          "#{property.property_name}:datetime"
        else
          "#{property.property_name}:#{schema[:type]}"
        end
      end
    end

    def action_names(links)
      links.map(&:link_name).each_with_object([]) do |name, array|
        # NOTE:
        # ex)
        #   show_user => show
        #   create_user => create
        #   list_users => index
        name = name.to_s
        if name =~ /list_#{plural_name}\Z/
          array << 'index'
        elsif name =~ /(?<action>.*)_#{singular_name}\Z/
          array << Regexp.last_match(1)
        end
      end
    end

    def route(routing_code)
      # NOTE: see https://github.com/rails/rails/blob/v5.0.0.beta3/railties/lib/rails/generators/actions.rb#L234-L241
      log :route, routing_code
      sentinel = /scope :api(.*)do\s*\n/m
      config = { after: sentinel, verbose: false, force: false }

      in_root do
        inject_into_file 'config/routes.rb', "#{routing_code}\n".indent(4), config
      end
    end
  end
end
