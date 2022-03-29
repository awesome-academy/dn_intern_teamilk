class SessionsController < ApplicationController
  include SessionsHelper
  before_action :find_user_by_email, :check_authenticated,
                :check_activated, only: %i(create)

  def new; end

  def create; end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def check_activated
    remember_me = params[:session][:remember_me]
    if @user.activated
      log_in @user
      remember @user if remember_me == "1"
      redirect_back_or root_url
    else
      message = t "sessions.create.no_activation"
      flash[:warning] = message
      redirect_to login_url
    end
  end

  def check_authenticated
    return true if @user&.authenticate params[:session][:password]

    flash.now[:danger] = t "sessions.create.wrong_pass"
    render :new
  end

  def find_user_by_email
    @user = User.find_by email: params[:session][:email].downcase
    return if @user

    flash.now[:danger] = t "sessions.create.user_not_found"
    render :new
  end
end
