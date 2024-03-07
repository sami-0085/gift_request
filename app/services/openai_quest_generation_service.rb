class OpenaiQuestGenerationService
  def initialize(query, api_key)
    @query = query
    @api_key = api_key
  end

  def call
    client = OpenAI::Client.new(access_token: @api_key)
    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: "あなたは作詞家です" },
          { role: "user", content: generate_prompt(@query) }
        ],
      }
    )

    response.dig("choices", 0, "message", "content")
  end

  private

  def generate_prompt(query)
    "以下の条件で歌詞を出題してください。

    # 条件
    テーマ: #{query}
    歌詞にテーマの言葉#{query}は使わないでください。
    テイスト: ラブソング
    Output should be less than 300 tokens

    # output
    タイトル: 20文字以内
    歌詞: 句読点で改行して下さい。
    テーマのヒント:30文字以内で3つ、format:-ヒント1
    テーマ: 3択、format:-選択肢1"
  end
end
