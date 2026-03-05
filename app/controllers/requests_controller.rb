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

  def update
    @request = Request.find(params[:id])
    boolean = ActiveModel::Type::Boolean.new
    fullness = boolean.cast(params[:request][:fullness]) ? 'complet' : 'incomplet'
    newness  = boolean.cast(params[:request][:newness])  ? 'neuf' : "d'occasion"
    system_prompt = "#{fullness}, #{newness} et #{params[:request][:cleanliness]}"
    @request.system_prompt = system_prompt
    if @request.update(request_params)
      redirect_to request_path(@request)
    else
      render :show, status: :unprocessable_entity
    end
  end


  def destroy
    @request = Request.find(params[:id])
    if @request.destroy
      redirect_to requests_path, notice: ""
    else
      redirect_to requests_path, alert: @request.errors.full_messages
    end
  end

  def show
    @request = Request.find(params[:id])
    @chats = @request.chats.where(user: current_user)

    @prefilled_request = Request.new( fullness: @request.fullness, cleanliness: @request.cleanliness, newness: @request.newness)
  end

  private

  def request_params
    params.require(:request).permit(:cleanliness, :fullness, :newness, :system_prompt, :photo)
  end
end
