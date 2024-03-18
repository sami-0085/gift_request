class QuestsController < ApplicationController
  skip_before_action :require_login, only: %i[show choice]
  def show
    @quest = Request.find(params[:id])
  end

  def choice
    @quest = Request.find(params[:id])
  end
end
