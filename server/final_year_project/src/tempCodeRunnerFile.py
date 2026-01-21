@app.get("/analogy")
async def analogy( concept: str, theme_name:  str = "sports"):
    bart_output = bart_simplify(concept)
    feasible, score, analogy_text = generate_analogy(theme_name=theme_name, concept=bart_output)
    if feasible:
        return {
            "feasibility_score": score,
            "analogy": analogy_text
        }
    else:
        return {
            "feasibility_score": score,
            "message": "No valid analogy can be generated for this concept."
        }