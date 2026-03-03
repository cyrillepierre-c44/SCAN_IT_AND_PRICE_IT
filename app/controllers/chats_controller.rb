class ChatsController < ApplicationController
  def show
    @chat = Chat.find(params[:id])
  end

  def create
    @chat = Chat.new(chat_params)
    if @chat.save
      redirect_to request_path(@chat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:title, :user_id, :request_id)
  end
end
