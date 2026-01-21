import ollama  # Import the Ollama library

# Send a test message to the LLaMA 3 model (or any available model)
response = ollama.chat(
    model="llama3.2",  # Change this to another model if needed (e.g., "gemma" or "mistral")
   messages = [
    {"role": "system", "content": "You are a text simplification assistant. Given a complex sentence, generate three levels of simplification: \n\n1. **Basic Simplification:** Retain most details but simplify words and sentence structure.\n2. **Intermediate Simplification:** Make it even easier to read, shortening long explanations.\n3. **Elementary Simplification:** Reduce it to the simplest possible form, suitable for young children or non-native speakers.\n\nFormat your response as:\n\n**Basic:** <simplified text>\n**Intermediate:** <simplified text>\n**Elementary:** <simplified text>\n"},
    
    {"role": "user", "content": "Here is a sentence to simplify: 'The intricate design of the monument exemplifies the architectural brilliance of the 18th century.'"}
]


)

# Print the AI's response
print("AI Response:", response["message"]["content"])
