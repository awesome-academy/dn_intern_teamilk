class PagesController < ApplicationController
  authorize_resource class: PagesController

  def home
    return unless user_signed_in? && current_user.admin?

    flash[:success] = t "index.hello_admin"
    redirect_to admin_path
  end
end
