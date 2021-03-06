class UsersController < ApplicationController
  require 'uri'
  # for devise
  before_filter :authenticate_user!, only: [:edit, :update]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes
    @posts = @user.posts.limit(3)
    @comments = @user.comments.limit(4)
    @reviews = @user.reviews.limit(4)
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new(user_params)
    
    if @user.save
       flash[:success] = 'You have been signed up for RecipeBox! Welcome!'
       redirect_to current_user
    else
      render 'new'
    end
  end
  
  def crop
    @user = User.find(params[:id])
  end
 
  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
        if params[:user][:avatar].present?
          render :crop
        else
          redirect_to current_user
          flash[:success] = 'Profile was successfully updated'
        end
    else
      render :edit
    end
  end
  
  def generate_new_password_email
      user = User.find(params[:user_id])
      user.send_reset_password_instructions
      flash[:notice] = "Reset password instructions have been sent to #{user.email}."
      redirect_to admin_user_path(user)
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :first_name, :last_name, :username, :location, :profile, :avatar, :crop_x, :crop_y, :crop_w, :crop_h)
    end
end
