import torch
from transformers import BartForConditionalGeneration, BartTokenizer, GenerationConfig

# Define the local model path
MODEL_PATH = "./models/bart_large_cnn"

# Load the model and tokenizer from the local directory
tokenizer = BartTokenizer.from_pretrained(MODEL_PATH)
model = BartForConditionalGeneration.from_pretrained(MODEL_PATH)

# Set up proper generation configuration instead of modifying model.config directly
generation_config = GenerationConfig.from_pretrained(MODEL_PATH)
generation_config.forced_bos_token_id = 0
generation_config.save_pretrained(MODEL_PATH)

def simplify_text(text, level="moderate"):
    """
    Simplifies the given text based on the chosen level.
    
    Levels:
    - minimal: Slight simplification, keeps most details.
    - moderate: Balanced simplification.
    - extreme: Maximum simplification, shorter output.
    """
    level_config = {
    "minimal": {
        "max_length": 100,          # Allows moderately long outputs
        "min_length": 10,           # Ensures basic completeness
        "num_beams": 4,             # Balanced beam search
        "length_penalty": 0.9,      # Slight preference for shorter output
        "temperature": 0.8,         # Moderate creativity
        "top_p": 0.95               # Expands word choices while keeping focus
    },
    "moderate": {
        "max_length": 70,           # Shorter but still detailed
        "min_length": 10,           # Avoids overly short outputs
        "num_beams": 6,             # More beam exploration
        "length_penalty": 0.8,      # Encourages conciseness
        "temperature": 0.7,         # Slightly more deterministic
        "top_p": 0.92               # Keeps variety within reason
    },
    "extreme": {
        "max_length": 60,           # Very concise output
        "min_length": 5,            # Allows super-short summaries
        "num_beams": 8,             # More exhaustive search
        "length_penalty": 0.6,      # Strongly discourages long outputs
        "temperature": 0.6,         # Less randomness, more clarity
        "top_p": 0.9                # Limits vocabulary even further
    }
}


    
    if level not in level_config:
        raise ValueError("Invalid level. Choose from: minimal, moderate, extreme.")
    
    config = level_config[level]
    
    # Tokenize input text
    inputs = tokenizer(text, return_tensors="pt", max_length=1024, truncation=True)
    
    # Generate simplified text using the generation_config
    with torch.no_grad():
        outputs = model.generate(
            inputs.input_ids,
            generation_config=generation_config,
            max_length=config["max_length"],
            min_length=config["min_length"],  # Added explicit min_length
            num_beams=config["num_beams"],
            length_penalty=config["length_penalty"]
        )
    
    simplified_text = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return simplified_text

# Example usage
if __name__ == "__main__":
    text = """The quick brown fox jumps over the lazy dog. It was a sunny day, and the fox was feeling energetic.
    However, the lazy dog was in no mood to play. The fox tried multiple times to engage the dog, 
    but it remained unbothered, lying under the shade of an old tree."""
    
    print("\nMinimal:", simplify_text(text, level="minimal"))
    print("\nModerate:", simplify_text(text, level="moderate"))
    print("\nExtreme:", simplify_text(text, level="extreme"))
    
    
    
    