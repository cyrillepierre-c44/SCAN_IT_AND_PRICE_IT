class MessagesController < ApplicationController
SYSTEM_PROMPT = "Vous êtes un expert en vente d'articles d'occasion de toutes sortes. Je travaille pour une entreprise qui vend des jouets d'occasion et je souhaiterais savoir à quel prix je peux les vendre. Peux-tu m'aider à trouver le meilleur prix d'occasion en tenant compte du prix du neuf et des prix pratiqués par la concurrence?"

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

    redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def request_context
    "Pour évaluer le prix de vente de l'objet, tu dois impérativement tenir compte du contexte suivant, l'objet est #{@request.system_prompt}. Merci de me faire une réponse courte de 20 mots maximum avec une seule fourchette de prix bas"
  end

  def process_file(file)
    if file.content_type == "application/pdf"
      send_question(model: "gemini-2.0-flash", with: { pdf: @message.file.url })
    elsif file.image?
      send_question(model: "gpt-4o", with: { image: @message.file.url })
    end
  end

  def send_question (model: "gpt-4.1", with: {})
    @ruby_llm_chat = RubyLLM.chat(model: model)
    build_conversation_history
    question = @ruby_llm_chat.with_instructions(instructions)
    puts question
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

  def instructions
    toto = [SYSTEM_PROMPT, request_context].compact.join(" ")
  end
end
