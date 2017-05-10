class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  # need access control on the destroy action so only admins can destroy other users
  before_action :admin_user,      only: :destroy
  
  def new
    @user = User.new  
  end
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    if !@user.activated?
      redirect_to root_url
      flash[:info] = "This user has not been activated."
    end
    
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params) # update attributes takes hash of attributes to update
      flash[:success] = "Profile saved successfully!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
    private
    
      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
      
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
      
      def correct_user # confirms a correct user
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
      end
      
      # conrims an admin user
      def admin_user
        redirect_to(root_url) unless current_user.admin?
      end
end
