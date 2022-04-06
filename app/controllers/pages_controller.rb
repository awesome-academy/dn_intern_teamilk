class PagesController < ApplicationController
  def home
    return unless User.find_by(id: session[:user_id])&.admin?

    flash[:success] = t "index.hello_admin"
    redirect_to admin_path
  end
end
