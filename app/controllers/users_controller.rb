class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.avatar.attach(params[:user][:avatar])
    if @user.save
      redirect_to login_path
      flash[:notice] = '新規作成しました'
    else
      flash.now[:alert] = '新規作成に失敗しました'
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    @user_requests = @user.requests.order(created_at: :desc).page(params[:page])
    logger.debug @user_requests.inspect
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(current_user), info: 'ユーザー情報を編集しました'
    else
      flash.now[:alert] = '編集に失敗しました'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :reset_password_token)
  end
end
