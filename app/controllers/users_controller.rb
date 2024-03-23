class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.avatar.attach(params[:user][:avatar])
    if @user.save
      login(user_params[:email], user_params[:password])
      flash[:notice] = t('users.create.success')
      redirect_to root_path
    else
      flash.now[:alert] = t('users.create.failure')
      render 'new', status: :unprocessable_entity
    end
  end

  private
  #reset_password_token受け取る必要あるか？
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :reset_password_token)
  end
end
