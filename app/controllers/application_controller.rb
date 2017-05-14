class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
    private
      
      def logged_in_user # confirms a logged in user
        unless is_logged_in?
          store_location #this method is in session_helper and stores the intended original url in session hash under Lforwarding_url key
          flash[:danger] = "Please log in to access this page."
          redirect_to login_path
          # this goes to the login page
          # once u go to the login page and try to login, it runs session_controller create method
          # redirect_back_or is at the end of the create method, forwarding to a store_location if any
        end
      end
end
