class AdminController < ApplicationController
  before_action :login?, :admin?

  def index; end

  private
  def login?
    @current_user = User.find_by(id: session[:user_id])
    return if @current_user

    flash[:danger] = t "admin_index.not_logged_in"
    redirect_to root_url
  end

  def admin?
    return if @current_user.admin?

    flash[:danger] = t "admin_index.can_not_accesss"
    redirect_to root_url
  end
end
