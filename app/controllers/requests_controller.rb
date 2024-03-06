class RequestsController < ApplicationController
  skip_before_action :require_login
  before_action :set_token, :text_params, only: :search

  def search
    @client = OpenAI::Client.new(access_token: @api_key)
    response = @client.chat(
      parameters: {
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: @query }],
      })

    @chats = response.dig("choices", 0, "message", "content")
  end

  private

  def text_params
    @query = params[:text]
  end

  def set_token
    @api_key = Rails.application.credentials.dig(:openai, :api_key)
  end
end
