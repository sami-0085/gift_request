class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create guest_login]

  def new; end

  def create
    login(params[:email], params[:password]) do |user, failure|
      if user && !failure
        redirect_back_or_to(root_path, notice: t('user_sessions.create.success'))
      else
        case failure
        when :invalid_login
          flash.now[:alert] = t('errors.flash_messages.invalid_login')
        when :invalid_password
          flash.now[:alert] = t('errors.flash_messages.invalid_password')
        when :inactive
          flash.now[:alert] = t('errors.flash_messages.inactive')
        end
        render action: 'new', status: :unprocessable_entity

      end
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other, flash: { info: t('user_sessions.destroy.success') }
  end

  def guest_login
    @guest_user = User.create(
    name: 'ゲスト',
    email: SecureRandom.alphanumeric(10) + "@email.com",
    password: 'password',
    password_confirmation: 'password'
    )
    auto_login(@guest_user)
    flash[:notice] = "ゲストとしてログインしました。再度ログインできないのでご注意ください。"
    redirect_to new_request_path
  end
end
