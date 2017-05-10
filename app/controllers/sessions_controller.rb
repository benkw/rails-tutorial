class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) # any other object besides nil and false is true
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user # sessions_helper method for friendly forwarding # rails automatically converts this to the route for user profile page user_url(user)
      else
        message = "Account not activated. "
        message += "CHeck your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # flash an error msg
      flash.now[:danger] = 'Invalid email/password combination. Please try again!'
      # rerendering a template without render doesnt count as a request
      render 'new' # render new.html.erb (aka the log in page)
    end
  end
  
  def destroy
    log_out if is_logged_in?
    redirect_to root_url
  end
  
end
