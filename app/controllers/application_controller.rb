class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :require_login

  private

  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end

  protected
  def is_admin?
    if current_user.try(:admin?)
      true
    else
      false
    end
  end

  def admin_required
    unless is_admin?
      redirect_to root_path, alert: "You are so cool..."
    end
  end
end
