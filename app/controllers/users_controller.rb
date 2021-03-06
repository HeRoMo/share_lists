class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :require_login, only: [:new, :create]

  # GET /users/1
  # GET /users/1.json
  def show
    # TODO 自分以外のユーザの情報を見れない様にすべきか？
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    unless admin_or_self?
      redirect_to action: :show, id: @user.id
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        @user = login(user_params[:email], user_params[:password])
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        # format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    unless admin_or_self?
      respond_to do |format|
        format.html {redirect_to :root, alert: 'Cannot update other user.'}
      end
      return
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path(@user), notice: 'User was successfully updated.' }
        # format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    unless admin_or_self?
      respond_to do |format|
        format.html {redirect_to :root, alert: 'Cannot delete other user.'}
      end
      return
    end

    @user.destroy
    redirect_path = (current_user.admin?)? admin_user_path: root_path
    respond_to do |format|
      format.html { redirect_to redirect_path, notice: 'User was successfully destroyed.' }
      # format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # adminユーザからか、あるいは自分自身へのアクセスかを判定する
  # @return リクエストがadominユーザまたは自分自身の場合 true それ以外はfalse。
  def admin_or_self?
    current_user.admin? || current_user == @user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    if @user.try(:admin?)
      params.require(:admin).permit(:email, :password, :password_confirmation)
    else
      params.require(:user ).permit(:email, :password, :password_confirmation)
    end
  end

end
