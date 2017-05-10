module SessionsHelper
  
  def log_in(user)
    session[:user_id] = user.id # temporary cookie made my sessions method - automatically encrypted
  end
  
  # returns the user corresponding to the remember token cookie
  def current_user
    # @current_user = @current_user || User.find_by(id: session[:user_id])
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def is_logged_in?
    !current_user.nil?
  end
  
  def log_out # logs out of the current user, no need for an argument
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # Remembers a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # friendly forwarding
  #redirects to stored location (or to the default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  #stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  
end
