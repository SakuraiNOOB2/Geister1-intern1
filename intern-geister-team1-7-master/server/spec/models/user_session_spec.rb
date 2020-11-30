# == Schema Information
#
# Table name: user_sessions
#
#  id           :integer          not null, primary key
#  access_token :string           not null
#  user_id      :integer          not null
#  active       :boolean          default(FALSE), not null
#  expires_at   :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_user_sessions_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe UserSession, type: :model do
  def find_user_session(user_session)
    UserSession.find(user_session.id)
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:user) }
  end

  describe '#activate' do
    let(:user_session) { create :user_session, active: false }

    subject { user_session.active? }
    before { user_session.activate }

    it { is_expected.to be_truthy }
  end

  describe '#activate!' do
    subject { user_session.activate! }

    before { user_session.update_attributes(active: false) }

    let(:user_session) { create :user_session }

    it { expect { subject }.to change { find_user_session(user_session).active }.from(false).to(true) }
  end

  describe '#inactivate' do
    let(:user_session) { create :user_session, active: true }

    subject { user_session.active? }
    before { user_session.inactivate }

    it { is_expected.to be_falsey }
  end

  describe '#inactivate!' do
    subject { user_session.inactivate! }

    let(:user_session) { create :user_session, active: true }

    it { expect { subject }.to change { find_user_session(user_session).active }.from(true).to(false) }
  end

  describe '#set_expiration' do
    subject { user_session.expires_at }

    before do
      Timecop.freeze(current_time)
      user_session.set_expiration!
    end

    let(:user_session) { create :user_session }
    let(:current_time) { Time.local(2016, 8, 1, 0, 0, 0, 0) }
    let(:expires_at) { current_time + described_class::AVAILABLE_TIME }

    it { is_expected.to eq expires_at }
  end

  describe '#set_expiration!' do
    subject { user_session.set_expiration! }

    before do
      Timecop.freeze(current_time)
      user_session.update_attributes(expires_at: before_time)
    end

    let(:user_session) { create :user_session, expires_at: Time.local(2016, 8, 9) }
    let(:current_time) { Time.local(2016, 8, 10) }
    let(:before_time) { Time.local(2016, 8, 9) }
    let(:after_time) { current_time + 1.hour }

    it { expect { subject }.to change { find_user_session(user_session).expires_at }.from(before_time).to(after_time) }
  end

  describe '#expired?' do
    subject { user_session.expired? }

    before do
      Timecop.freeze(current_time)
      user_session.set_expiration!
      Timecop.travel(now)
    end

    let(:user_session) { create :user_session }
    let(:current_time) { Time.local(2016, 8, 1, 0, 0, 0, 0) }

    context 'when now in the future than expires_at' do
      let(:now) { user_session.expires_at + 1.hour }

      it { is_expected.to be_truthy }
    end

    context 'when now not in the future than expires_at' do
      let(:now) { user_session.expires_at - 1.hour }

      it { is_expected.to be_falsey }
    end
  end
end
