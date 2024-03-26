#OpenaiQuestGenerationServiceを利用してクエストを生成し、生成されたクエスト情報（クエスト本文、タイトル、ヒント、選択肢）を処理してデータベースに保存
class CreateQuestService
  def initialize(user_request, api_key)
    @user_request = user_request
    @api_key = api_key
  end

  def call
    # OpenaiQuestGenerationServiceの呼び出し
    service = OpenaiQuestGenerationService.new(@user_request.name, @api_key)
    response = service.call
    process_response(response)
  end

  private

  def process_response(response)
    # 抽出したデータを保存
    match_quest = response.match(/歌詞:([\s\S]+?)- テーマのヒント:/)&.[](1)
    match_title = response.match(/タイトル:(.+?)\n/)&.[](1)
    hints = extract_hints(response)
    match_choices = extract_choices(response)
    # 抽出したデータを@user_requestに保存
    @user_request.quest = match_quest
    @user_request.title = match_title
    # Rails.logger.debug "match_quest value: #{match_quest.inspect}"

    if @user_request.save
      save_hints(hints)
      save_choices(match_choices)
      true # 保存が成功した場合、trueを返し、それ以外の場合はfalse
    else
      false
    end
  end

  def extract_hints(response)
    {
      1 => response.match(/ヒント1:(.+?)\n/)&.[](1),
      2 => response.match(/ヒント2:(.+?)\n/)&.[](1),
      3 => response.match(/ヒント3:(.+?)\n/)&.[](1)
    }
  end

  def extract_choices(response)
    {
      1 => response.match(/選択肢1:(.+?)\n/)&.[](1),
      2 => response.match(/選択肢2:(.+?)\n/)&.[](1),
      3 => response.match(/選択肢3:(.+)/m)&.[](1)
    }
  end


  def save_hints(hints)
    hints.each do |number, content|
      @user_request.hints.create(number: number, content: content) if content
    end
  end

  def save_choices(choices)
    choices.each do |number, content|
      @user_request.choices.create(number: number, content: content) if content
    end
  end
end
