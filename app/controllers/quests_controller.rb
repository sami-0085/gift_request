class QuestsController < ApplicationController
  skip_before_action :require_login, only: %i[show choice answer correct hint]
  before_action :set_quest, only: %i[show choice answer correct hint]

  def show; end

  def choice; end

  def answer
    # choice ビューからの入力を受け取る
    user_input = params[:name]&.strip
    # hint ビューからの選択を受け取る
    selected_choice = params[:selected_choice]&.strip
    # ユーザー入力が存在するか、選択された選択肢が存在するかを確認
    answer = user_input.presence || selected_choice
    # 正解を判定する条件
    correct_answer = @quest.name.strip
    if answer.present? && correct_answer == answer
      # 正解の場合の処理
      redirect_to correct_quest_path(@quest), notice: "正解です！おめでとうございます！"
    else
      # 不正解または入力がない場合の処理
      redirect_to hint_quest_path(@quest), alert: "残念、不正解です。手がかりをヒントにもう一度挑戦しよう！"
    end
  end

  def correct; end

  def hint; end

  private

  def set_quest
    @quest = Request.find(params[:id])
  end
end
