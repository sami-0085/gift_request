class RequestsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :set_token, only: %i[create]
  before_action :request_params, only: %i[create edit]
  before_action :set_request, only: %i[edit update destroy]

  def index
    @user_requests = Request.all.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def new
    @user_request = Request.new
  end

  def create
    @user_request = current_user.requests.build(request_params)
    service = CreateQuestService.new(@user_request, @api_key)
    if service.call
      redirect_to @user_request, notice: t('requests.create.success')
    else
      flash.now[:alert] = t('requests.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user_request = Request.find(params[:id])
  end

  def edit; end

  def update
    if @user_request.update(request_params)
      redirect_to @user_request, notice: t('users.update.success')
    else
      flash.now[:alert] = t('users.update.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_request.destroy!
    redirect_to requests_path, notice: 'クエストを削除しました', status: :see_other
  end

  private

  def set_request
    @user_request = current_user.requests.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:name, :remarks, :desired_date)
  end

  def set_token
    @api_key = Rails.application.credentials.dig(:openai, :api_key)
  end
end
