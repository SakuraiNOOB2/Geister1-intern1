class ClientGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def generate_api_class_def
    template(
      'ApiClassDef.cs.erb',
      Rails.root.join('../', 'unity', 'Assets', 'Scripts', 'Utility', 'HTTP', 'ApiClassDef.cs'),
      config
    )
  end

  def generate_api_client
    template(
      'ApiClient.cs.erb',
      Rails.root.join('../', 'unity', 'Assets', 'Scripts', 'Utility', 'HTTP', 'ApiClient.cs'),
      config
    )
  end

  private

  def config
    { links: links }
  end

  def links
    @links ||= GeisterProtocol::Schema.properties.map(&:links).flatten
  end
end
