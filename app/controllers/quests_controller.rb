class QuestsController < ApplicationController
  skip_before_action :require_login, only: %i[show choice]
  before_action :set_quest, only: %i[show choice]

  def show; end

  def choice; end

  private

  def set_quest
    @quest = Request.find(params[:id])
  end
end
