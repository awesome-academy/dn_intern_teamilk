class PagesController < ApplicationController
  authorize_resource class: PagesController

  def home
    return unless logged_in? && admin

    flash[:success] = t "index.hello_admin"
    redirect_to admin_path
  end
end
