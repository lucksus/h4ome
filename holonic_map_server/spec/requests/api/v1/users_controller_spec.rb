require 'rails_helper'

RSpec.describe API::V1::UsersController do
  describe 'POST user' do
    def do_post
      post '/api/v1/users', params: params
    end

    context 'with valid registration params' do
      let :params do
        {email: 'test@mail.de', username: 'tester', password: 'blablub123', password_confirmation: 'blablub123'}
      end

      it 'creates a new user' do
        expect{
          do_post
        }.to change{User.count}.by(1)
      end

      it 'returns status success' do
        do_post
        expect(response).to be_success
      end
    end

    context 'with unmatched passwords' do
      let :params do
        {email: 'test@mail.de', password: 'blablub123', password_confirmation: 'blablub'}
      end

      it 'does not create a new user' do
        expect{
          do_post
        }.not_to change{User.count}
      end

      it 'returns status bad request' do
        do_post
        expect(response.code).to eq '400'
      end
    end

    context 'with used email' do
      let!(:user) {FactoryGirl.create(:user)}
      let(:params) { {email: user.email, password: 'blablub123', password_confirmation: 'blablub123'} }

      it 'does not create a new user' do
        expect{
          do_post
        }.not_to change{User.count}
      end

      it 'returns status bad request' do
        do_post
        expect(response.code).to eq '400'
      end

    end
  end
end
