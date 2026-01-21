import ollama

# Initialize the client
client = ollama.Client()

# Define model and prompt
model = "llama3.2"  # Change this based on the model you want to use
prompt = "okay so i want you to give me a json forma to of an examplw a group of my friends, name, age and hair color in a json format. I want exactly 5 friends so be as creative as possible and mess around with it"

# Generate response
response = client.generate(model=model, prompt=prompt)

# Print output
print(response["response"])
