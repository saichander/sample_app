# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#

class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
  end
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to sample app!"
      redirect_to @user
    else
      render 'new'
    end
  end
  def edit
    @user=User.find(params[:id])
  end
  def update
    @user=User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  #Before filters
  #confirms a logged in user

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please Log In."
      redirect_to login_url
    end
  end
  #confirms correct user
  def correct_user
    @user=User.find_by(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
