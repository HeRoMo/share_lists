require 'rails_helper'
include Sorcery::TestHelpers::Rails::Controller

describe Admin::UsersController, type: :controller do

  describe "GET #index" do
    context 'not logined access' do
      before do
        @user = create(:user)
        get :index
      end
      it { expect(response).to redirect_to login_path}
      it { expect(assigns(:users)).to be nil }
    end
    context "login as admin" do
      before do
        @admin = create(:admin)
        @user = create(:user)
        login_user @admin
        get :index
      end
      it { expect(response).to have_http_status(:success)}
      it { expect(assigns(:users)).not_to be nil }
      it { expect(assigns(:users)).to eq [@admin, @user] }
    end
    context "login as user" do
      before do
        @admin = create(:admin)
        @user = create(:user)
        login_user @user
        get :index
      end
      it { expect(response).to have_http_status(:found)}
      it { expect(response).to redirect_to :root}
      it { expect(assigns(:users)).to be nil }
    end
  end
end
