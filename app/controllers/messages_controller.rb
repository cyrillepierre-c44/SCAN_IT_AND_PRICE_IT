class MessagesController < ApplicationController
SYSTEM_PROMPT = "You are an expert in second hand vendor for all types of objects.\n\nI am a person working for a compagny that sells second hand objects as toys, wanted to know how much can I sell them.\n\nHelp me to find the best second hand price regarding the cost of new and the second hand price you can find if you look at the competitors.\n\nAnswer me inside a table with a mid, low and high prices you will advise."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @request = @chat.request

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    @chat.generate_title_from_first_message

    if @message.save
      if @message.file.attached?
        process_file(@message.file)
      else
        send_question
      end

    @chat.messages.create(role: "assistant", content: @response.content)
    @chat.generate_title_from_first_message

    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private




  def process_file(file)
    if file.content_type == "application/pdf"
      send_question(model: "gemini-2.0-flash", with: { pdf: @message.file.url })
    elsif file.image?
      send_question(model: "gpt-4o", with: { image: @message.file.url })
    end
  end

  def send_question (model: "gpt-4", with: {})
    @ruby_llm_chat = RubyLLM.chat(model: model)
    build_conversation_history
    @ruby_llm_chat.with_instructions(instructions)
    @response = @ruby_llm_chat.ask(@message.content, with: with)
  end

  def message_params
  params.require(:message).permit(:content, :file)
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end

  def request_context
    "Here is the context of the request: #{@request.system_prompt}."
  end

  def process_file(file)
    if file.content_type == "application/pdf"
      send_question(model: "gemini-2.0-flash", with: { pdf: @message.file.url })
    elsif file.image?
      send_question(model: "gpt-4o", with: { image: @message.file.url })
    end
  end

  def send_question (model: "gpt-4", with: {})
    @ruby_llm_chat = RubyLLM.chat(model: model)
    # build_conversation_history
    @ruby_llm_chat.with_instructions(SYSTEM_PROMPT)
    @response = @ruby_llm_chat.ask(@message.content, with: with)
  end

  def instructions
    [SYSTEM_PROMPT, request_context, @request.system_prompt].compact.join("\n\n")
  end

end
