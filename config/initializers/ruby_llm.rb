RubyLLM.configure do |config|
  config.openai_api_key = ENV["GITHUB_KEY"]
  config.openai_api_base = "https://models.inference.ai.azure.com"
  response = chat.ask "Describe this image.", with: { image: "tmp/lewagon-student.png" }
  puts response.content
  # ... see RubyLLM configuration guide for other models
end
