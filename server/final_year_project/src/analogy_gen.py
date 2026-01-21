from langchain_ollama.llms import OllamaLLM
from langchain_core.prompts import ChatPromptTemplate
from src.vector import get_retriever
from src.feasibility import is_feasible_analogy

# === Load model and setup prompt chain ===
model = OllamaLLM(model="llama3.2:3b", temperature=0.7)

analogy_prompt_template = """
You are an expert in creating sharp, simple analogies using a given theme category.

Your task is to explain the concept {concept} using a single analogy drawn from the theme {theme_name}.

CONSTRAINT: If you cannot produce a valid analogy based on the {theme_name} theme, say so clearly.

Theme: {theme_name}
Relevant Info: {theme_text}
Concept: {concept}

Instructions:
- Use **only one** metaphor from the **{theme_name}** theme.
- Keep it to **1–2 sentences** max.
- Do **not** list multiple examples or explain the analogy.
- If you can’t produce a valid analogy within **{theme_name}**, just say:
  "No valid {theme_name} analogy can be generated for this concept."
"""

analogy_prompt = ChatPromptTemplate.from_template(analogy_prompt_template)
analogy_chain = analogy_prompt | model


def generate_analogy(theme_name: str, concept: str, threshold: float = 0.35):
    """
    Generates an analogy for the given concept based on the specified theme.

    Args:
        theme_name (str): The theme to draw the analogy from.
        concept (str): The concept to explain.
        threshold (float): Feasibility score threshold (0-1) for generating the analogy.

    Returns:
        tuple:
            feasible (bool): Whether a valid analogy could be generated.
            score (float): The feasibility score.
            analogy (str or None): The generated analogy, or None if not feasible.
    """
    # Retrieve theme documents
    retriever = get_retriever(theme_name)
    theme_docs = retriever.invoke(concept)

    # Check feasibility
    feasible, score = is_feasible_analogy(concept, theme_docs, threshold)
    if not feasible:
        return False, score, None

    # Combine top documents for context
    theme_text = "\n".join([doc.page_content for doc in theme_docs[:2]])

    # Generate the analogy
    analogy = analogy_chain.invoke({
        "theme_name": theme_name,
        "theme_text": theme_text,
        "concept": concept
    }).strip()

    return True, score, analogy


if __name__ == "__main__":
    # Simple hard-coded test
    theme = "classroom"
    concept_text = "hardwork never pays"
    feasible, score, analogy = generate_analogy(theme, concept_text)
    if feasible:
        print(f"\n✅ Feasibility score: {score:.2f}")
        print(f"📘 Generated Analogy:\n{analogy}")
    else:
        print(f"\n❌ Feasibility score: {score:.2f}")
        print(f"No valid {theme} analogy can be generated for this concept.")