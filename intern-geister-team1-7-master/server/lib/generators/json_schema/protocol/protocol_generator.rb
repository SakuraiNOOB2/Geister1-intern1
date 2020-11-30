module JsonSchema
  class ProtocolGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    argument :attributes, type: :array, default: [], banner: 'field:type field:type'

    class_option(
      :actions,
      type: :array,
      default: %w(index show create update delete).join(' '),
      desc: 'define link for protorol',
      banner: 'index show create update delete'
    )

    def create_protocol
      path = Rails.root.join('lib', 'geister_protocol', "#{singular_name}.rb")
      config = { actions: options[:actions].inquiry, attributes: attributes }

      template 'protocol.rb.erb', path, config
    end

    def create_protocol_spec
      path = Rails.root.join('spec', 'lib', 'geister_protocol', "#{singular_name}_spec.rb")
      converted_attributes = [':id', ':created_at', ':updated_at'].concat(attributes.map { |attr| ":#{attr.name}" })
      config = { actions: options[:actions].inquiry, attributes: converted_attributes }

      template 'protocol_spec.rb.erb', path, config
    end

    def add_protocol_to_root
      code = "\nproperty(:#{singular_name}, links: true, type: #{singular_name.camelize})".indent(2)
      config = { before: /\nend/, force: true, verbose: true }

      inject_into_file Rails.root.join('lib', 'geister_protocol.rb'), code, config
    end
  end
end
