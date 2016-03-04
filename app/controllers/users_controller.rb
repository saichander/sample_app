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
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    #render 'show' if current_user?(@user)
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
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
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    if current_user.admin?
      @user.destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    else
      flash[:danger] = "You should be admin to delete an user"
      redirect_to users_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user=User.find(params[:id])
  end

  #confirms correct user
  def correct_user
    @user=User.find_by(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
