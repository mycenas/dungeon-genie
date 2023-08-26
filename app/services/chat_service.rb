class ChatService
  attr_reader :message

  def initialize(message:)
    @message = message
  end

  def call
    messages = training_prompts.map do |prompt|
      { role: "system", content: prompt}
    end

    messages << { role: "user", content: message}

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: messages,
        temperature: 0.7,
      }
    )

    response.dig("choices", 0, "message", "content")
  end

  private

  def training_prompts
    [
      "Do you know what a Dungeon Master is?",
      "Can you pretend to be a Dungeon Master from now on? Answer yes or no",
    ]
  end

  def client
    @_client ||= OpenAI::Client.new
  end
end
