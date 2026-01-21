import os
from langchain_ollama import OllamaEmbeddings
from langchain_chroma import Chroma
from langchain_core.documents import Document

#  Load and split a text file into word chunks
def load_chunks_from_text(filepath, chunk_size=500):
    with open(filepath, "r", encoding="utf-8") as f:
        text = f.read()
    words = text.split()
    chunks = [" ".join(words[i:i+chunk_size]) for i in range(0, len(words), chunk_size)]
    return [
        Document(page_content=chunk, metadata={"source": filepath}, id=str(i))
        for i, chunk in enumerate(chunks)
    ]

#  Main function to get retriever based on theme name (e.g., "sports", "classroom")
def get_retriever(theme_name="sports"):
    theme_file = f"data/{theme_name}.txt"
    if not os.path.exists(theme_file):
        raise FileNotFoundError(f"{theme_file} does not exist.")
    
    db_path = f"db/chroma_{theme_name}_db"
    collection_name = f"{theme_name}_analogies"

    documents = load_chunks_from_text(theme_file)
    embeddings = OllamaEmbeddings(model="mxbai-embed-large")
    
    vector_store = Chroma(
        collection_name=collection_name,
        persist_directory=db_path,
        embedding_function=embeddings
    )

    if len(vector_store.get()['ids']) == 0:
        vector_store.add_documents(documents=documents)

    return vector_store.as_retriever(search_kwargs={"k": 5})
