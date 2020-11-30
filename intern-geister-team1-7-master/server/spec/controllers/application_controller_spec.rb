require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#render_error' do
    subject { controller.render_error(exception) }

    let(:exception) { ApplicationController::APIError.new(message) }
    let(:message)   { 'render_error test' }

    it 'should call to #render with correct options' do
      options = { json: { id: exception.id, message: exception.message }, status: exception.status }
      expect_any_instance_of(described_class).to receive(:render).with(options)
      subject
    end
  end

  describe '#json_params' do
    subject { controller.json_params }

    before { allow(request).to receive(:body).and_return(StringIO.new(json)) }

    context 'when valid json' do
      let(:json) { { id: 'foo', password: 'bar' }.to_json }
      let(:expected_parameter) { ActionController::Parameters.new(JSON.parse(json, symbolized_names: true)) }

      it { is_expected.to eq expected_parameter }
    end

    context 'when invalid json' do
      let(:json) { 'invalid json' }
      let(:expected_parameter) { ActionController::Parameters.new {} }

      it { is_expected.to eq expected_parameter }
    end
  end

  describe '#current_session' do
    include_context 'login'

    subject { controller.current_session }

    it { is_expected.to eq current_session }
  end

  describe '#authenticate!' do
    subject { controller.authenticate! }

    before { allow(controller).to receive(:current_session).and_return(current_session) }

    context 'when current_session is nil' do
      let(:current_session) { nil }

      it 'should render error of UnAuthorizedError' do
        expect(controller).to receive(:render_error).with(
          an_instance_of(Errors::UnAuthorizedError)
        )
        subject
      end
    end

    context 'when current_session is expired' do
      let(:current_session) { create :user_session }

      before { allow(current_session).to receive(:expired?).and_return(true) }

      it 'should render error of UnAuthorizedError' do
        expect(controller).to receive(:render_error).with(
          an_instance_of(Errors::SessionExpiredError)
        )
        subject
      end
    end

    context 'when current_session is not expired' do
      let(:current_session) { create :user_session }

      before { allow(current_session).to receive(:expired?).and_return(false) }

      it 'should receive update_expiration! of current_session' do
        expect(current_session).to receive(:update_expiration!)
        subject
      end
    end
  end
end
