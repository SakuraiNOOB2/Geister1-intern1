shared_context 'request describer' do
  SUPPORTED_METHODS = %w(GET POST DELETE PUT).freeze unless const_defined?(:SUPPORTED_METHODS)

  subject { send http_method, path, params: params.to_json, headers: headers }

  let(:headers)     { { 'Content-type' => 'application/json' } }
  let(:params)      { Hash.new }
  let(:http_method) { endpoint_segments[1].downcase }
  let(:path)        { endpoint_segments[2].gsub(/:(\w+[!?=]?)/) { send(Regexp.last_match(1)) } }

  let(:endpoint_segments) do
    current_example = RSpec.respond_to?(:current_example) ? RSpec.current_example : example
    current_example.full_description.match(/(#{SUPPORTED_METHODS.join("|")}) (\S+)/).to_a
  end
end
