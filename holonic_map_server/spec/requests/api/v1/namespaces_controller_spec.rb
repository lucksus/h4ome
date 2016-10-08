require 'rails_helper'

RSpec.describe API::V1::NamespacesController do
  describe 'GET namespaces/{path}' do
    def do_get
      get '/api/v1/namespaces/' + path
    end

    context 'with non-existing path' do
      let(:path) {"silly/sausage"}

      it 'responds with namespace not found message' do
        do_get
        expect(response.body).to have_json_path('meta')
        expect(json[:meta]).to be_a Hash
        expect(json[:meta][:errors][0][:message]).to eql "namespace not found"
      end

      it 'returns status not found' do
        do_get
        expect(response.code).to eq '404'
      end


    end

    context 'with valid user path' do
      let!(:user) {FactoryGirl.create(:user)}
      let(:path) {"/home/" + user.username}

      it 'does respond with the namespace hash' do
        do_get
        expect(response.body).to have_json_path('data')
        expect(json[:data]).to be_a Hash
        expect(json[:data][:hash]).to eql user.home_hash
      end

      it 'returns status success' do
        do_get
        expect(response.code).to eq '200'
      end
    end
  end

  describe 'PUT namespaces{path}' do
    def do_put
      put '/api/v1/namespaces/' + path, params: { hash: hash }, headers: headers
    end

    context 'with non-existing path' do
      let(:path) {"silly/sausage"}
      let(:hash) {"asdfasdasdf"}

      it 'responds with namespace not found message' do
        do_put
        expect(response.body).to have_json_path('meta')
        expect(json[:meta]).to be_a Hash
        expect(json[:meta][:errors][0][:message]).to eql "namespace not found"
      end

      it 'returns status not found' do
        do_put
        expect(response.code).to eq '404'
      end
    end

    context 'with valid user path' do
      let!(:user) {FactoryGirl.create(:user)}
      let(:path) {"/home/" + user.username}
      let(:hash) {"asdfasdasdf"}

      context 'with logged in user' do
        before { authWithUser(user) }

        it 'changes the users home_hash' do
          expect{
            do_put
          }.to change{User.find(user.id).home_hash}.to "asdfasdasdf"
        end

        it 'returns status success' do
          do_put
          expect(response.code).to eq '200'
        end
      end

      context 'without logged in user' do
        it 'does not change the users home_hash' do
          expect{
            do_put
          }.not_to change{User.find(user.id).home_hash}
        end

        it 'returns 401 status' do
          do_put
          expect(response.code).to eq '401'
        end
      end

    end


    context 'with non-existing path' do
      let!(:user) {FactoryGirl.create(:user)}
      let(:path) {"/silly/sausage" + user.username}
      let(:hash) {"asdfasdasdf"}

      context 'with logged in user' do
        before { authWithUser(user) }

        it 'does not change the users home_hash' do
          expect{
            do_put
          }.not_to change{User.find(user.id).home_hash}
        end

        it 'returns 404 status' do
          do_put
          expect(response.code).to eq '404'
        end
      end

      context 'without logged in user' do
        it 'does not change the users home_hash' do
          expect{
            do_put
          }.not_to change{User.find(user.id).home_hash}
        end

        it 'returns 404 status' do
          do_put
          expect(response.code).to eq '404'
        end
      end

    end
  end
end
