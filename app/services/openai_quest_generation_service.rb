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
          { role: "system", content: "You are a professional lyricist." },
          { role: "user", content: generate_prompt(@query) }
        ],
      }
    )

    response.dig("choices", 0, "message", "content")
  end

  private

  def generate_prompt(query)
    "Please create lyrics based on the following conditions.

    # Conditions
    Theme: #{query}
    Do not use the theme word #{query} in the lyrics.
    Taste: longing
    Plese answer in Japanese.
    Output should be less than 300 tokens

    # Required Output
    - タイトル: Please provide a title within 20 characters, enclosed in quotation marks (「」).
    - 歌詞: Write the lyrics within 300 characters.
    - テーマのヒント: Provide 3 hints related to the theme, each within 30 characters, formatted as follows:
      - ヒント1:
      - ヒント2:
      - ヒント3:
    - Theme choices: Provide 3 choices for the theme, one of which is the actual theme #{query}, formatted as follows:
      - 選択肢1:
      - 選択肢2:
      - 選択肢3:

    Please ensure all four components (Title, Lyrics, Theme hints, and Theme choices) are clearly included in your response."
  end
end
