class QuestsController < ApplicationController
  skip_before_action :require_login, only: %i[show choice show_card]
  before_action :set_quest, only: %i[show choice show_card]

  def show; end

  def choice; end

  def show_card
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to choice_quest_path(@quest), alert: "Action not supported." }
    end
  end


  private

  def set_quest
    @quest = Request.find(params[:id])
  end
end
