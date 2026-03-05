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

  # def edit
  # end

  # def update
  # end

  # def destroy
  # end

  def show
    @request = Request.find(params[:id])
    @chats = @request.chats.where(user: current_user)
  end

  private

  #   def process_file(file)
  #   if file.content_type == "application/pdf"
  #     send_question(model: "gemini-2.0-flash", with: { pdf: @message.file.url })
  #   elsif file.image?
  #     send_question(model: "gpt-4o", with: { image: @message.file.url })
  #   end
  # end

  # def send_question (model: "gpt-4", with: {})
  #   @ruby_llm_chat = RubyLLM.chat(model: model)
  #   # build_conversation_history
  #   @ruby_llm_chat.with_instructions(SYSTEM_PROMPT)
  #   @response = @ruby_llm_chat.ask(@message.content, with: with)
  # end

  def request_params
    params.require(:request).permit(:cleanliness, :fullness, :newness, :system_prompt, :photo)
  end
end
