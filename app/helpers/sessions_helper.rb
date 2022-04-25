module SessionsHelper
  def redirect_back_or default
    redirect_to(session[:fowarding_url] || default)
    session.delete(:fowarding_url)
  end

  def store_location
    session[:fowarding_url] = request.original_url if request.get?
  end

  def admin
    current_user.admin?
  end
end
