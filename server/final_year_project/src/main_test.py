# from bart_simplifier import bart_simplify
# from llm_refine import simplify_text
# from evaluation import evaluate_with_rouge, evaluate_with_bertscore
# from analogy_gen import generate_analogy


from src.bart_simplifier import bart_simplify
from src.llm_refine import simplify_text
from src.evaluation import evaluate_with_rouge, evaluate_with_bertscore
from src.analogy_gen import generate_analogy



if __name__ == "__main__":
#     original_text = """
#    In the field of psychology, cognitive dissonance is described as a mental phenomenon in which people unknowingly hold fundamentally conflicting cognitions.[1] Being confronted by situations that challenge this dissonance may ultimately result in some change in their cognitions or actions to cause greater alignment between them so as to reduce this dissonance.
#     """
    
    original_text =  """
    Quantum mechanics is the fundamental physical theory that describes the behavior of matter and of light; its unusual characteristics typically occur at and below the scale of atoms. It is the foundation of all quantum physics, which includes quantum chemistry, quantum field theory, quantum technology, and quantum information science.
    """

    bart_output = bart_simplify(original_text)
    bart_evaluation = evaluate_with_rouge(original_text, bart_output)

    print("\n=== BART SUMMARY ===")
    print(f"BART Output: {bart_output}\n")
    print(f"ROUGE Evaluation: {bart_evaluation}")

    print("\n===SIMPLIFICATION ===")
    model = "llama3.2"
    for level in ["level_1", "level_2", "level_3"]:
        simplified_text = simplify_text(original_text, bart_output, level=level, model=model)
        simplified_text_evaluation = evaluate_with_bertscore(original_text, simplified_text)

        print(f"\n=== {level.upper()} ===")
        print(f"Simplified Text: {simplified_text}\n")
        print(f"BERTScore Evaluation: {simplified_text_evaluation}")

    print('')
    print('------------------------------------------')
    print("\n=== ANALOGY GENERATION ===")
    # theme = "classroom"
    # concept_text = "hardwork never pays"
    feasible, score, analogy = generate_analogy(theme_name='sports', concept=bart_output )
    if feasible:
        print(f"\n✅ Feasibility score: {score:.2f}")
        print(f"📘 Generated Analogy:\n{analogy}")
    else:
        print(f"\n❌ Feasibility score: {score:.2f}")
        print("No valid analogy can be generated for this concept.")
        
    print('')
    print('------------------------------------------')
    # analogy generation evaluation
    analogy_evavluation = evaluate_with_bertscore(original_text, analogy)
    print("\n=== ANALOGY EVALUATION ===")
    print(f"Analogy Evaluation: {analogy_evavluation}")
    