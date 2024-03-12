class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def show
    @user_requests = current_user.requests.order(created_at: :desc).page(params[:page])
    logger.debug @user_requests.inspect
  end

  def edit;end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: t('defaults.message.updated', item: User.model_name.human)
    else
      flash.now['alert'] = t('defaults.message.not_updated', item: User.model_name.human)
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :avatar_cache)
  end
end
