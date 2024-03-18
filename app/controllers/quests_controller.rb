class QuestsController < ApplicationController
  skip_before_action :require_login, only: %i[show]
  def show
    @quest = Request.find(params[:id])
  end
end
