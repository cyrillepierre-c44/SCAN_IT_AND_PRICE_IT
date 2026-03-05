class RequestsController < ApplicationController
  def index
    @requests = Request.all
  end

  def new
    @request = Request.new
  end

  def create
    @request  = Request.new(request_params)
    if @request.save
      if ///////////
      redirect_to request_path(@request)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
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
