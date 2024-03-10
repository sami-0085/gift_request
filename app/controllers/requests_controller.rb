class RequestsController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  before_action :set_token, :request_params, only: %i[create]

  def index
    @requests = Request.all.includes(:user).order(created_at: :desc)
  end

  def new
    @request = Request.new
  end

  def create
    @request = current_user.requests.build(request_params)
    service = OpenaiQuestGenerationService.new(@request.name, @api_key)
    response = service.call
    # 抽出したデータを保存
    match_quest = response.match(/歌詞:([\s\S]+?)- テーマのヒント:/)&.[](1)
    match_title = response.match(/タイトル:(.+?)\n/)&.[](1)
    hints = {
      1 => response.match(/ヒント1:(.+?)\n/)&.[](1),
      2 => response.match(/ヒント2:(.+?)\n/)&.[](1),
      3 => response.match(/ヒント3:(.+?)\n/)&.[](1)
    }
    match_choices = {
      1 => response.match(/選択肢1:(.+?)\n/)&.[](1),
      2 => response.match(/選択肢2:(.+?)\n/)&.[](1),
      3 => response.match(/選択肢3:(.+)/m)&.[](1)
    }
    if match_quest
      @request.quest = match_quest
      @request.title = match_title if match_title
      if @request.save
        # ヒントを保存
        hints.each do |number, content|
          @request.hints.create(number: number, content: content) if content
        end
        match_choices.each do |number, content|
          @request.choices.create(number: number, content: content) if content
        end
        redirect_to @request, notice: 'リクエストが正常に作成されました。'
      else
        render :new, status: :unprocessable_entity
      end
    else
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
