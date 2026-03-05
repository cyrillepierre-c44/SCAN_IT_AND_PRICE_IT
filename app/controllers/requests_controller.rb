class RequestsController < ApplicationController
  SYSTEM_PROMPT = "You are an expert in second hand vendor for all types of objects.\n\nI am a person working for a compagny that sells second hand objects as toys, wanted to know how much can I sell them.\n\nHelp me to find the best second hand price regarding the cost of new and the second hand price you can find if you look at the competitors.\n\nAnswer me inside a table with a mid, low and high prices you will advise."

  def index
    @requests = Request.all
  end

  def new
    @request = Request.new
  end

  def create
    @request  = Request.new(request_params)
      if @request.save!
        redirect_to request_path(@request)
      else
        render :new, status: :unprocessable_entity
      end
  end

  def update
    @request = Request.find(params[:id])
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
