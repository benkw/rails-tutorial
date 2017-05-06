module SessionsHelper
  
  def log_in(user)
    session[:user_id] = user.id # temporary cookie made my sessions method - automatically encrypted
  end
  
  def current_user
    # @current_user = @current_user || User.find_by(id: session[:user_id])
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def is_logged_in?
    !current_user.nil?
  end
  
  def log_out # logs out of the current user, no need for an argument
    session.delete(:user_id)
    @current_user = nil
  end
  
end
