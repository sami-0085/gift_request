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
    service = OpenaiQuestGenerationService.new(@user_request.name, @api_key)
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
      @user_request.quest = match_quest
      @user_request.title = match_title if match_title
      if @user_request.save
        # ヒントを保存
        hints.each do |number, content|
          @user_request.hints.create(number: number, content: content) if content
        end
        match_choices.each do |number, content|
          @user_request.choices.create(number: number, content: content) if content
        end
        redirect_to @user_request, notice: 'クエストが作成されました。'
      else
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = 'クエストの生成に失敗しました。'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user_request = Request.find(params[:id])
  end

  def edit; end

  def update
    if @user_request.update(request_params)
      redirect_to @user_request, notice: '編集しました'
    else
      flash.now[:alert] = '編集に失敗しました'
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
