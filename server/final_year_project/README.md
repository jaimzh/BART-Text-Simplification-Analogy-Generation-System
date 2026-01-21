# Text Simplification & Analogy Generation API

This project is a FastAPI-based backend server designed to simplify complex text and generate analogies using advanced NLP models. It leverages BART for initial simplification and integrates LLMs (like Llama 3.2) for further refinement and analogy generation.

## Features

- **Text Simplification**: Reduces text complexity using BART and refines it with LLMs.
- **Analogy Generation**: Creates analogies for simplified concepts based on themes (e.g., sports).
- **Real-time Streaming**: Supports WebSockets for streaming text and analogy generation token-by-token.
- **Vector Database Integration**: Uses ChromaDB for RAG-based operations.

## Installation

1.  **Navigate to the server directory**:

    ```bash
    cd server/final_year_project
    ```

2.  **Create a virtual environment**:

    ```bash
    python -m venv venv
    ```

3.  **Activate the virtual environment**:
    - **Windows**:
      ```bash
      venv\Scripts\activate
      ```
    - **macOS/Linux**:
      ```bash
      source venv/bin/activate
      ```

4.  **Install dependencies**:
    ```bash
    pip install -r requirements.txt
    ```

## Usage

To start the server, run the following command from the `server/final_year_project` directory:

```bash
uvicorn src.app:app --reload
```

_The server will start at `http://127.0.0.1:8000`._

## API Endpoints

### HTTP Endpoints

- `GET /`: Health check ("up and running").
- `GET /simplify?text=...`: Basic simplification using BART.
- `GET /llm_simplify?text=...&level=level_1`: Simplification with LLM refinement.
- `GET /analogy?concept=...&theme_name=sports`: Generates an analogy for a given concept.
- `GET /process?text=...`: Combined endpoint that returns both simplified text and an analogy.

### WebSocket Endpoints

- `WS /process_ws`: Streams simplified text and analogies in real-time.
- `WS /process_chunks_ws`: Advanced streaming with chunked responses for better UI feedback.

## Project Structure

- `src/`: Source code for the application.
  - `app.py`: Main FastAPI application entry point.
  - `bart_simplifier.py`: BART model logic.
  - `llm_refine.py`: LLM refinement logic.
  - `analogy_gen.py`: Analogy generation with RAG.
- `data/`: Text data files (e.g., classroom, sports).
- `db/`: ChromaDB vector stores.
- `models/`: Local model files (ignored by git).
