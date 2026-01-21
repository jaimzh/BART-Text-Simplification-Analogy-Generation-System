# Text Simplification & Analogy Generation System

This repository contains the source code for a comprehensive system designed to simplify complex text and generate analogies to aid understanding. It consists of a mobile/cross-platform client built with Flutter and a backend integration server built with Python (FastAPI).

## Project Structure

The project is divided into two main components:

### 1. Server (`server/`)

A Python-based backend that exposes REST API and WebSocket endpoints.

- **Tech Stack**: FastAPI, PyTorch, Transformers (BART), LangChain, ChromaDB.
- **Key Features**:
  - Text simplification using a fine-tuned BART model.
  - Advanced refinement using LLMs (e.g., Llama 3.2).
  - Analogy generation for specific themes (e.g., Sports, Classroom) using RAG (Retrieval-Augmented Generation).
  - Real-time streaming via WebSockets.

### 2. Client (`client/`)

A cross-platform application (Mobile/Web) that interacts with the backend to provide a user-friendly interface for text simplification.

- **Tech Stack**: Flutter (Dart).
- **Key Features**:
  - Clean UI for inputting text.
  - Real-time display of simplified text and analogies.
  - Voice integration (if applicable).

## Getting Started

### Prerequisites

- **Python 3.10+**
- **Flutter SDK**
- **Git**

### Installation

1.  **Clone the repository**:

    ```bash
    git clone <your-repo-url>
    cd <repo-name>
    ```

2.  **Setup the Server**:
    Navigate to the server directory and follow the instructions in `server/final_year_project/README.md`.

    ```bash
    cd server/final_year_project
    # Create venv, install requirements, and run server
    ```

3.  **Setup the Client**:
    Navigate to the client application directory.
    ```bash
    cd client/final_year_project_flutter/final_year_project
    flutter pub get
    flutter run
    ```

## Usage

Ensure the server is running on `http://127.0.0.1:8000` (or your configured host) before launching the client application. The client is configured to communicate with this local server.
