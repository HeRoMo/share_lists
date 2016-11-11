require 'rails_helper'
include Sorcery::TestHelpers::Rails::Controller

describe UsersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    before do
      @user = create(:user)
      get :index
    end
    context 'not logined access' do
      it { expect(assigns(:users)).not_to be nil }
      it { expect(assigns(:users)).to eq([@user]) }
    end
  end

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
    context "with valid params" do
      let(:new_attributes) {
        {email: 'new@email.com',
         password: 'new_password',
         password_confirmation: 'new_password'}
      }
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

    it "redirects to the users list" do
      user = create :user
      login_user user
      delete :destroy, id: user.id
      expect(response).to redirect_to(root_url)
    end
  end

end
