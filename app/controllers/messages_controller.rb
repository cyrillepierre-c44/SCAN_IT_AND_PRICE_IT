class MessagesController < ApplicationController
SYSTEM_PROMPT = "You are an expert in second hand vendor.\n\nI am a person working for a compagny that sells second hand objetcs as toys, wanting to know how much can I sell thems after cleaning.\n\nHelp me break to find the best second hand price regarding the cost of new and the second hand prcie you can fin if you lok the competitors.\n\nAnswer with à mid, low and high prices."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @request = @chat.request

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    @chat.generate_title_from_first_message

    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)

      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
  params.require(:message).permit(:content)
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end

  def request_context
    "Here is the context of the request: #{@request.system_prompt}."
  end

  def instructions
    [SYSTEM_PROMPT, request_context, @request.system_prompt].compact.join("\n\n")
  end

end
