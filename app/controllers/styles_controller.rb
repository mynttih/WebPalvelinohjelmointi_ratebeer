class StylesController < ApplicationController
  before_action :set_style, only: [:show]
  before_action :ensure_that_user_is_admin, only: [:destroy]

  def index
    @styles = Style.all
  end

  def set_style
    @style = Style.find(params[:id])
  end
end
