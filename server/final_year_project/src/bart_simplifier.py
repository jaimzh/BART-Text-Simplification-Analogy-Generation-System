import torch
from transformers import BartForConditionalGeneration, BartTokenizer

# Define the local model path
MODEL_PATH = "./models/bart_large_cnn"

# Load the model and tokenizer from the local directory
tokenizer = BartTokenizer.from_pretrained(MODEL_PATH)
model = BartForConditionalGeneration.from_pretrained(MODEL_PATH)

def bart_simplify(text):
    # Tokenize input text
    inputs = tokenizer(text, return_tensors="pt", max_length=1024, truncation=True)
    
    # Set the generation config instead of passing parameters directly
    model.generation_config.max_length = 80
    model.generation_config.min_length = 10
    model.generation_config.num_beams = 8
    model.generation_config.length_penalty = 0.7
    model.generation_config.repetition_penalty = 1.3
    model.generation_config.do_sample = False
    
    # Generate simplified text using the updated generation config
    with torch.no_grad():
        outputs = model.generate(inputs.input_ids)
    
    simplified_text = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return simplified_text

# Example usage
if __name__ == "__main__":
    text = """The quick brown fox jumps over the lazy dog. It was a sunny day, and the fox was feeling energetic.
    However, the lazy dog was in no mood to play. The fox tried multiple times to engage the dog, 
    but it remained unbothered, lying under the shade of an old tree."""
    
    print(bart_simplify(text))