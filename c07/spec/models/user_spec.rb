require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.find_or_create_with_oauth' do
    subject { User.find_or_create_with_oauth(oauth_data) }

    let(:oauth_data) { OmniAuth::AuthHash.new(uid: uid, provider: provider, credentials: { token: SecureRandom.uuid }, info: { email: 'user@examples.com' }) }
    let(:uid)        { '12345678' }
    let(:provider)   { 'provider' }

    context 'ユーザーが存在している場合' do
      before do
        @user = create(:user, uid: uid, provider: provider, token: 'before_token')
      end

      it 'Userオブジェクトが返ってくること' do
        expect(subject.class).to eq User
      end

      it 'トークンが更新されていること' do
        expect(subject.token).to eq oauth_data.credentials.token
      end
    end

    context 'ユーザーが存在しない場合' do
      it 'Userオブジェクトが返ってくること' do
        response = subject
        expected_value = { uid: uid, provider: provider, email: 'user@examples.com' }.stringify_keys
        expect(response.class).to eq User
        expect(response.attributes).to include expected_value
      end
    end
  end
end
