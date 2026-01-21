from rouge_score import rouge_scorer
from bert_score import score as bert_score
import warnings

# Suppress the specific warning about uninitialized pooler weights
# warnings.filterwarnings(
#     "ignore",
#     message=r"Some weights of .* were not initialized from the model checkpoint.*"
# )

def evaluate_with_rouge(reference_text, generated_text):
    """
    Evaluates text quality using ROUGE scores.
    """
    scorer = rouge_scorer.RougeScorer(['rouge1', 'rouge2', 'rougeL'], use_stemmer=True)
    scores = scorer.score(reference_text, generated_text)
    
    return {
        "ROUGE-1": round(scores["rouge1"].fmeasure, 4),
        "ROUGE-2": round(scores["rouge2"].fmeasure, 4),
        "ROUGE-L": round(scores["rougeL"].fmeasure, 4)
    }

def evaluate_with_bertscore(reference_text, generated_text):
    """
    Evaluates semantic similarity using BERTScore.
    """
    P, R, F1 = bert_score([generated_text], [reference_text], lang="en", verbose=False,  model_type="roberta-large-mnli", rescale_with_baseline=False)
    
    return {
        "BERTScore-Precision": round(P.mean().item(), 4),
        "BERTScore-Recall": round(R.mean().item(), 4),
        "BERTScore-F1": round(F1.mean().item(), 4)
    }








# from rouge_score import rouge_scorer
# # from bert_score import score as bert_score
# from bert_score import BERTScorer


# _scorer = BERTScorer(
#     model_type="roberta-large-mnli",
#     lang="en",
#     rescale_with_baseline=True
# )

# def evaluate_with_rouge(reference_text, generated_text):
#     """
#     Evaluates text quality using ROUGE scores.
#     """
#     scorer = rouge_scorer.RougeScorer(['rouge1', 'rouge2', 'rougeL'], use_stemmer=True)
#     scores = scorer.score(reference_text, generated_text)
    
#     return {
#         "ROUGE-1": round(scores["rouge1"].fmeasure, 4),
#         "ROUGE-2": round(scores["rouge2"].fmeasure, 4),
#         "ROUGE-L": round(scores["rougeL"].fmeasure, 4)
#     }

# def evaluate_with_bertscore(reference_text, generated_text):
#     """
#     Evaluates semantic similarity using BERTScore.
#     """
#     P, R, F1 = _scorer.score([generated_text], [reference_text], verbose=False)
    
#     return {
#         "BERTScore-Precision": round(P.mean().item(), 4),
#         "BERTScore-Recall": round(R.mean().item(), 4),
#         "BERTScore-F1": round(F1.mean().item(), 4)
#     }
