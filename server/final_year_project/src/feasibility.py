from langchain_ollama import OllamaEmbeddings
from langchain_core.documents import Document
import numpy as np

# Set up embeddings (same model used during vector store creation)
embedding_model = OllamaEmbeddings(model="mxbai-embed-large")

def cosine_similarity(vec1, vec2):
    return np.dot(vec1, vec2) / (np.linalg.norm(vec1) * np.linalg.norm(vec2))

def is_feasible_analogy(concept: str, theme_docs: list[Document], threshold: float = 0.6):
    concept_emb = embedding_model.embed_query(concept)
    max_similarity = 0

    for doc in theme_docs:
        doc_emb = embedding_model.embed_query(doc.page_content)
        similarity = cosine_similarity(concept_emb, doc_emb)
        if similarity > max_similarity:
            max_similarity = similarity
        if similarity >= threshold:
            return True, max_similarity

    return False, max_similarity
