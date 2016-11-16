class MypageController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /users/1
  # GET /users/1.json
  def show
    expires_now
    @own_lists = @user.lists
    @favorite_lists = @user.favorite_lists
  end

  # # GET /users/1/edit
  # def edit
  #   if @user.id != current_user.id
  #     redirect_to action: :show, id: @user.id
  #   end
  # end

  # # PATCH/PUT /users/1
  # # PATCH/PUT /users/1.json
  # def update
  #   # TODO 自分かAdmin以外編集不可にする
  #   respond_to do |format|
  #     if @user.update(user_params)
  #       format.html { redirect_to @user, notice: 'User was successfully updated.' }
  #       # format.json { render :show, status: :ok, location: @user }
  #     else
  #       format.html { render :edit }
  #       # format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /users/1
  # # DELETE /users/1.json
  # def destroy
  #   # TODO 自分かAdmin以外削除不可にする
  #   @user.destroy
  #   respond_to do |format|
  #     format.html { redirect_to :root, notice: 'User was successfully destroyed.' }
  #     # format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

end
