# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_name  (name) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'association' do
    it { should have_many(:user_sessions) }
    it { should have_one(:player_entry) }
    it { should have_one(:spectator_entry) }
  end

  describe 'validation' do
    it { should have_secure_password }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:password) }

    it 'should which one of player_entry and spectator_entry to be absence' do
      user = create :user
      room = create :room
      user.spectator_entry = create :spectator_entry, room: room, user: user
      user.player_entry = create :player_entry, index: 1, room: room, user: user

      expect(user.valid?).to be_falsey
    end
  end

  describe 'name validation' do
    subject { user }

    context 'when not valid pattern given' do
      let(:user) { build(:user, name: '@@@') }
      it { is_expected.not_to be_valid }
    end

    context 'when valid pattern given' do
      let(:user) { build(:user) }
      it { is_expected.to be_valid }
    end
  end

  describe 'password validation' do
    subject { user }

    context 'when not valid pattern given' do
      let(:user) { build(:user, password: '@@@') }
      it { is_expected.not_to be_valid }
    end

    context 'when valid pattern given' do
      let(:user) { build(:user) }
      it { is_expected.to be_valid }
    end
  end

  describe '.login' do
    subject { described_class.login(params) }
    let(:user) { create :user }

    context 'when valid user' do
      let(:params) { { name: user.name, password: user.password } }

      it { is_expected.to eq user }
    end

    context 'when invalid password' do
      let(:params) { { name: user.name, password: 'invalid password' } }

      it { is_expected.to be_nil }
    end

    context 'when invalid name' do
      let(:params) { { name: 'invalid name', password: user.password } }

      it { is_expected.to be_nil }
    end
  end
end
