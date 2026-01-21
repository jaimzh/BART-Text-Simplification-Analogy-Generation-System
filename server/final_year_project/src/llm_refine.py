import ollama
from src.bart_simplifier import bart_simplify
from rouge_score import rouge_scorer


# Simplification settings
SIMPLIFICATION_SETTINGS = {
    "level_1": "level 1 simplification: Rephrase sentences for better readability and flow. Improve structure while keeping all details and meaning intact.",
    "level_2": "level 2 simplification: Rewrites with simpler words and sentence structure, Use simpler words and break long sentences into smaller ones. Keep all key details but make it easier to read.",
    "level_3": "level 2 simplification:Use very basic words and very short sentences for learners with low literacy or language difficulties. Retain all important information while making it as clear and direct as possible."
}





def simplify_text(original_text, bart_output, level, model="llama3.2"):
    """
    Uses the original text and BART-simplified text to generate a refined version 
    based on the selected simplification level.
    """
    
    if level not in SIMPLIFICATION_SETTINGS:
        raise ValueError("Invalid level. Choose from: level_1, level_2, level_3, or combined.")

    messages = [
        {
            "role": "system",
            "content": (
                "You are a text simplification assistant. Your job is to refine text while ensuring clarity, "
                "accuracy, and meaning preservation.\n\n"
                "You always use two sources:\n"
                "1. The **Original Text** (as the main reference).\n"
                "2. The **BART-Simplified Text** (as a guide for simplification).\n\n"
                "Your goal is to improve readability while strictly following the user's requested simplification level.\n"
                "note we have 3 levels of simplification in general, level 1 is the most complex and level 3 is the simplest.\n"
            ),
        },
        {
            "role": "user",
            "content": f"""
            Simplify this text according to this rule: {SIMPLIFICATION_SETTINGS[level]}
            
            **Original Text:**
            {original_text}
            
            **BART Simplified Text:**
            {bart_output}
            
            Provide only the final simplified version. No explanations, no formatting, just the output.
            Try to ensure that the simplified text is not exactly the same as {bart_output} but uses it as a guide or reference.
            Also ensure that each level the length of the text is reduced slightly compared to the previous level. So level 1 should be the longest, and level 3 should be the shortest.
            """,
        },
    ]

    response = ollama.chat(model=model, messages=messages)
    return response["message"]["content"].strip()



#okay so this is the evaluation 
def evaluate_simplification(original_text, simplified_text):
    scorer = rouge_scorer.RougeScorer(['rouge1', 'rouge2', 'rougeL'], use_stemmer=True)
    scores = scorer.score(original_text, simplified_text)
    
    return {
        "ROUGE-1": scores["rouge1"].fmeasure,
        "ROUGE-2": scores["rouge2"].fmeasure,
        "ROUGE-L": scores["rougeL"].fmeasure
    }



