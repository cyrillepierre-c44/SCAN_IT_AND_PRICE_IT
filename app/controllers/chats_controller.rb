class ChatsController < ApplicationController
  def show
  end

  def create
    @request = Request.find(params[:challenge_id])

    @chat = Chat.new(title: "Untitled")
    @chat.request = @request
    @chat.user = current_user

  if @chat.save
    redirect_to chat_path(@chat)
  else
    @chats = @crequest.chats.where(user: current_user)
    render "requests/show"
  end
  end
end
