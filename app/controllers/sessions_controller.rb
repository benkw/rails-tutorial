class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) # any other object besides nil and false is true
      log_in user
      redirect_to user # rails automatically converts this to the route for user profile page user_url(user)
    else
      # flash an error msg
      flash.now[:danger] = 'Invalid email/password combination. Please try again!'
      # rerendering a template without render doesnt count as a request
      render 'new' # render new.html.erb (aka the log in page)
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  
end
