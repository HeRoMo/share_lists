require 'rails_helper'
include Sorcery::TestHelpers::Rails::Controller

describe UsersController, type: :controller do

  describe "GET #show" do
    context 'access to self ' do
      let(:id){ @user.id }
      before do
        @user = create(:user)
        login_user(@user)
        get :show, id: id
      end
      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:user)).to eq @user }
    end
    context 'access to other ' do
      let(:id){@other.id}
      before do
        @other = create(:user, email:"other@mail.com")
        @user = create(:user)
        login_user(@user)
        get :show, id: id
      end
      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:user)).to eq @other }
    end
    context 'no login access' do
      let(:id){ @user.id }
      before do
        @user = create(:user)
        get :show, id: id
      end
      it { expect(response).to have_http_status(:found) }
    end
  end

  describe "GET #new" do
    it "assigns a new user as @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "GET #edit" do
    context "assigns the requested user as @user" do
      before do
        @user = create(:user)
        login_user @user
        get :edit, id: @user.id
      end
      it { expect(assigns(:user)).to eq(@user) }
      it { expect(response).to have_http_status(:success)}
    end
    it 'acceass to other user' do
      user = create(:user)
      other = create(:user, email: 'other@email.com')
      login_user user
      get :edit, id: other.id
      expect(response).to redirect_to(action: :show, id: other.id)
    end
    context 'acceass to other user by admin' do
      before do
        admin = create(:admin)
        @user = create(:user)
        login_user admin
        get :edit, id: @user.id
      end
      it { expect(assigns(:user)).to eq(@user) }
      it { expect(response).to have_http_status(:success)}
    end

  end

  describe "POST #create" do
    context "with valid params" do
      let(:email){ 'test@email.com'}
      let(:password){ 'password'}

      it "creates a new User" do
        expect {
          post :create, user:{email: email, password: password, password_confirmation: password}
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, user:{email: email, password: password, password_confirmation: password}
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "redirects to the created user" do
        post :create, user: {email: email, password: password, password_confirmation: password}
        expect(response).to redirect_to(User.last)
      end
    end

    context "with invalid params" do
      let(:email){ 'invalid@mail.com'}
      let(:password){ 'password'}
      it "assigns a newly created but unsaved user as @user" do
        post :create, user: {email: email, password: password, password_confirmation: ''}
        expect(assigns(:user)).to be_a_new(User)
      end

      it "re-renders the 'new' template" do
        post :create, user: {email: email, password: password, password_confirmation: ''}
        expect(response).to render_template("new")
      end

      it 'duplicate email address' do
        User.create({email: email, password: password, password_confirmation: password})
        post :create, user: {email: email, password: password, password_confirmation: ''}
        expect(response).to render_template("new")
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end

  describe "PUT #update" do
    let(:new_attributes) {
      {email: 'new@email.com',
       password: 'new_password',
       password_confirmation: 'new_password'}
    }
    context "with valid params by user self" do
      before do
        @user = create(:user)
        login_user @user
        put :update, id: @user.id, user: new_attributes
      end

      it "updates the requested user" do
        @user.reload
        expect(@user.crypted_password).not_to eq Sorcery::CryptoProviders::BCrypt.encrypt("new_password", @user.salt)
      end

      it "assigns the requested user as @user" do
        expect(assigns(:user)).to eq(@user)
      end

      it "redirects to the user" do
        expect(response).to redirect_to(@user)
      end
    end

    context "with valid params by admin self" do
      before do
        @admin = create(:admin)
        login_user @admin
        put :update, id: @admin.id, admin: new_attributes
      end

      it "updates the requested user" do
        @admin.reload
        expect(@admin.crypted_password).not_to eq Sorcery::CryptoProviders::BCrypt.encrypt("new_password", @admin.salt)
      end

      it "assigns the requested user as @user" do
        expect(assigns(:user)).to eq(@admin)
      end

      it "redirects to the user" do
        expect(response).to redirect_to user_path(@admin)
      end
    end

    context "with invalid params" do
      let(:invalid_attributes){
        {email: 'new@email.com',
         password: 'new_password',
         password_confirmation: 'bad_password'}
      }
      before do
        @user = create :user
        login_user @user
        put :update, id: @user.id, user: invalid_attributes
      end
      it "assigns the user as @user" do
        expect(assigns(:user)).to eq(@user)
      end

      it "re-renders the 'edit' template" do
        expect(response).to render_template("edit")
      end
    end

    context 'update user by admin' do
      before do
        @admin = create(:admin)
        @user = create(:user)
        login_user @admin
        put :update, id: @user.id, user: new_attributes
      end
      it {expect(response).to redirect_to(user_path @user)}
      it {expect(assigns(:user).email).to eq new_attributes[:email]}
    end

    context 'update other user by normal user' do
      before do
        @login_user = create(:user)
        @target_user = create(:user)
        login_user @login_user
        put :update, id: @target_user.id, user: new_attributes
      end
      it {expect(response).to redirect_to root_path}
      it {expect(assigns(:user).email).not_to eq new_attributes[:email]}
    end

    it 'duplicate email address' do
      user1 = create(:user, email: 'user1@email.com')
      user2 = create(:user, email: 'user2@email.com')
      login_user user2
      put :update, id: user2.id, user: { email: 'user1@email.com', password:'password', password_confirmation: 'password'}
      expect(response).to render_template("edit")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      user = create :user
      expect {
        login_user user
        delete :destroy, id: user.id
      }.to change(User, :count).by(-1)
    end

    it "redirects to root" do
      user = create :user
      login_user user
      delete :destroy, id: user.id
      expect(response).to redirect_to(root_url)
    end
    context 'delete other user by admin' do
      before do
        admin = create(:admin)
        @user = create(:user)
        login_user admin
        delete :destroy, id: @user.id
      end
      it {expect(response).to redirect_to admin_user_path}
      it {expect(User.find_by(id:@user.id)).to be nil}
    end

    context 'delete other user by normal user' do
      before do
        login_user = create(:user)
        @target_user = create(:user)
        login_user login_user
        delete :destroy, id: @target_user.id
      end
      it {expect(response).to redirect_to root_url}
      it {expect(@target_user.reload).not_to be nil}
    end
  end

end
