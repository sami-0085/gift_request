class RequestsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  before_action :set_token, :request_params, only: [:create]

  def new
    @request = Request.new
  end

  def create
    @request = current_user.requests.build(request_params)
    service = OpenaiQuestGenerationService.new(@request.name, @api_key)
    response = service.call

    if response
      @request.quest = response
      if @request.save
        # redirect_to root_path, notice: 'リクエストが正常に作成されました。'
        redirect_to @request, notice: 'リクエストが正常に作成されました。'
      else
        render :new, status: :unprocessable_entity
      end
    else
      # エラーメッセージを設定
      flash.now[:alert] = 'クエストの生成に失敗しました。'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @request = Request.find(params[:id])
  end

  private

  def request_params
    params.require(:request).permit(:name, :remarks, :desired_date)
  end

  def set_token
    @api_key = Rails.application.credentials.dig(:openai, :api_key)
  end
end
