class RequestsController < ApplicationController
  def index
    @requests = Request.all
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def show
    @request = Request.find(params[:id])
    @chats = @request.chats.where(user_id: current_user.id)
  end

  private

  def request_params
    params.require(:request).permit(:cleanliness, :fullness, :newness, :system_prompt, :photo)
  end
end
