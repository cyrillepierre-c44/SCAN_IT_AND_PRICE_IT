class RequestsController < ApplicationController
  def index
    @requests = Request.all
  end

  def new
    @request = Request.new
  end

  def create
    @request  = Request.new(request_params)
    boolean = ActiveModel::Type::Boolean.new
    fullness = boolean.cast(params[:request][:fullness]) ? 'complet' : 'incomplet'
    newness  = boolean.cast(params[:request][:newness])  ? 'neuf' : "d'occasion"
    system_prompt = "#{fullness}, #{newness} et #{params[:request][:cleanliness]}"
    @request.system_prompt = system_prompt
    if @request.save!
      redirect_to request_path(@request)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @request = Request.find(params[:id])
    @chats = @request.chats.where(user: current_user)
  end

  private

  def request_params
    params.require(:request).permit(:cleanliness, :fullness, :newness, :system_prompt, :photo)
  end
end
