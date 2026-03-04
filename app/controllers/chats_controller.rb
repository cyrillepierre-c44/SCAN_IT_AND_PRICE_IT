class ChatsController < ApplicationController
  def show
    @chat    = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def create
    @request = Request.find(params[:request_id])

    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @chat.request = @request
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      @chats = @request.chats.where(user: current_user)
      render "requests/show"
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:title, :user_id, :request_id)
  end
end
