class QuestsController < ApplicationController
  skip_before_action :require_login, only: %i[show choice answer correct]
  before_action :set_quest, only: %i[show choice answer correct]

  def show; end

  def choice; end

  def answer
    selected_choice = params[:selected_choice]
    selected_choice = selected_choice.strip
    quest_name = @quest.name.strip

    if quest_name.include?(selected_choice)
      # 選択した選択肢が正解の場合、正解ページにリダイレクト
      redirect_to correct_quest_path(@quest), notice: "正解です！"
    else
      # 不正解の場合、選択肢のページにリダイレクト
      redirect_to choice_quest_path(@quest), alert: "不正解です。もう一度挑戦してください。"
    end
  end

  def correct
    
  end

  private

  def set_quest
    @quest = Request.find(params[:id])
  end
end
