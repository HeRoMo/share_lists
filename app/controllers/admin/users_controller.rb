class Admin::UsersController < ApplicationController

  before_action :admin_required

  # GET /admin/users
  # GET /admin/users.json
  def index
    @users = User.all
  end

end
