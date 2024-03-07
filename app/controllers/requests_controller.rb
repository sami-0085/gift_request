class RequestsController < ApplicationController
  skip_before_action :require_login
  before_action :set_token, :text_params, :request_params, only: [:create, :search]

  def new
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)
    @request.user = current_user
    service = OpenaiQuestGenerationService.new(@request.name, @api_key)
    response = service.call

    if response
      @request.quest = response
      if @request.save
        redirect_to root_path, notice: 'リクエストが正常に作成されました。'
        # redirect_to @request, notice: 'リクエストが正常に作成されました。'
      else
        render :new, status: :unprocessable_entity
      end
    else
      # エラーメッセージを設定
      flash.now[:alert] = 'クエストの生成に失敗しました。'
      render :new, status: :unprocessable_entity
    end
  end

  # def search
  #   @client = OpenAI::Client.new(access_token: @api_key)
  #   response = @client.chat(
  #     parameters: {
  #         model: "gpt-4",
  #         messages: [
  #           { role: "system", content: "あなたは作詞家です" },
  #           { role: "user", content:
  #             "以下の条件で歌詞を出題してください。

  #             # 条件
  #             テーマ: #{@query}
  #             歌詞にテーマの言葉#{@query}は使わないでください。
  #             テイスト: ラブソング
  #             Output should be less than 300 tokens

  #             # output
  #             タイトル: 20文字以内
  #             歌詞: 句読点で改行して下さい。
  #             テーマのヒント:30文字以内で3つ、format:-ヒント1
  #             テーマ: 3択、format:-選択肢1"}
  #         ],
  #     }
  #   )

  #   @chats = response.dig("choices", 0, "message", "content")
  # end

  private

  def request_params
    params.require(:request).permit(:name, :remarks, :desired_date)
  end

  def text_params
    @query = params[:text]
  end

  def set_token
    @api_key = Rails.application.credentials.dig(:openai, :api_key)
  end
end
