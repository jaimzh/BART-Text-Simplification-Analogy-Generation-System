from transformers import BartForConditionalGeneration, BartTokenizer

# Choose the pretrained model
model_name = "facebook/bart-large-cnn"

# Define the local save path
save_path = "./models/bart_large_cnn"

# Download and save the model + tokenizer locally
tokenizer = BartTokenizer.from_pretrained(model_name)
model = BartForConditionalGeneration.from_pretrained(model_name)

# Save model and tokenizer
model.save_pretrained(save_path)
tokenizer.save_pretrained(save_path)

print(f"Model saved to {save_path}")
