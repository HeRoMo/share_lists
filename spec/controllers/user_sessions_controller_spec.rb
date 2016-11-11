require 'rails_helper'
include Sorcery::TestHelpers::Rails::Controller

RSpec.describe UserSessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
      expect(assigns(:user)).not_to be nil
    end
  end

  describe "GET #create" do
    let(:email){ "whatever@whatever.com" }
    let(:password){ "secret" }
    before do
      create(:user, {email:"whatever@whatever.com", password:"secret", password_confirmation:"secret"})
      get :create, email: email, password:password
    end

    context "valid email and password" do
      it{ expect(response).to have_http_status(:found) }
    end
    context 'invalid email' do
      let(:email){'invalid@email.com'}
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template :new}
      it { expect(assigns(:user)).to be nil }
    end
    context 'invalid password' do
      let(:password){ 'invalid_password'}
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template :new}
      it { expect(assigns(:user)).to be nil }
    end
  end

  describe "GET #destroy" do
    before do
      user = create(:user)
      login_user(user)
    end
    it "returns http success" do
      get :destroy
      expect(response).to have_http_status(:found)
    end
  end

end
