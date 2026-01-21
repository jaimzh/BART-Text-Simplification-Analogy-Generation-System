# app.py

import asyncio
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from src.bart_simplifier import bart_simplify
from src.llm_refine import simplify_text
from src.analogy_gen import generate_analogy
import uvicorn

app = FastAPI()

@app.get("/")
async def root():
    return {"status": "up and running"}

@app.get("/simplify")
async def simplify(text: str):
    return {
        "original": text,
        "simplified": bart_simplify(text)
    }

@app.get("/llm_simplify")
async def llm_simplify(text: str, level: str = "level_1", model: str = "llama3.2"):
    bart_output = bart_simplify(text)
    simplified_text = simplify_text(text, bart_output, level=level, model=model)
    return {
        "original": text,
        "bart_output": bart_output,
        "simplified": simplified_text
    }
    
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
  

@app.get("/process")
async def process(
    text: str,
    level: str = "level_2",
    model: str = "llama3.2",
    theme_name: str = "sports"
):
    """
    Combined endpoint to return both simplified text and analogy.
    """
    # Simplification
    bart_output = bart_simplify(text)
    simplified_text = simplify_text(
        original_text=text,
        bart_output=bart_output,
        level=level,
        model=model
    )

    # Analogy generation
    feasible, score, analogy_text = generate_analogy(
        theme_name=theme_name,
        concept=bart_output
    )

    response = {
        "original": text,
        "bart_output": bart_output,
        "simplified": simplified_text,
        "feasibility_score": score
    }
    if feasible:
        response["analogy"] = analogy_text
    else:
        response["message"] = f"No valid {theme_name} analogy can be generated for this concept."

    return response

@app.websocket("/process_ws")
async def process_ws(websocket: WebSocket):
    """
    WebSocket endpoint that streams simplified text and analogy in real time.
    """
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_text()

            # Simplification
            bart_output = bart_simplify(data)
            simplified_text = simplify_text(
                original_text=data,
                bart_output=bart_output,
                level="level_2",
                model="llama3.2"
            )

            # Analogy generation
            feasible, score, analogy_text = generate_analogy(
                theme_name="sports",
                concept=bart_output
            )

            response = {
                "original": data,
                "bart_output": bart_output,
                "simplified": simplified_text,
                "feasibility_score": score
            }
            if feasible:
                response["analogy"] = analogy_text
            else:
                response["message"] = "No valid sports analogy can be generated for this concept."

            await websocket.send_json(response)
    except WebSocketDisconnect:
        print("WebSocket disconnected")
        return


@app.websocket("/process_chunks_ws")
async def process_chunks_ws(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            # Receive full JSON payload instead of raw text
            payload = await websocket.receive_json()
            text      = payload["text"]
            level     = payload.get("level", "level_2")
            model     = payload.get("model", "llama3.2")
            theme     = payload.get("theme_name", "sports")
            
            # 1) BART simplification
            bart_output = bart_simplify(text)
            await websocket.send_json({
                "type": "metadata",
                "original": text,
                "bart_output": bart_output
            })
            
            # 2) Stream simplified text
            simplified_text = simplify_text(
                original_text=text,
                bart_output=bart_output,
                level=level,
                model=model
            )
            await websocket.send_json({"type": "simplification_start"})
            for word in simplified_text.split():
                await websocket.send_json({
                    "type": "simplification_chunk",
                    "chunk": word  + " "
                    })
                await asyncio.sleep(0.05)
            await websocket.send_json({"type": "simplification_end"})
            
            # Analogy
            feasible, score, analogy_text = generate_analogy(
                theme_name=theme,
                concept=bart_output
            )
            await websocket.send_json({
                "type": "analogy_start", 
                "feasibility_score": score
                })
            if feasible:
                for word in analogy_text.split():
                    await websocket.send_json({
                        "type": "analogy", 
                        "chunk": word + " "
                        })
                    await asyncio.sleep(0.05)
            else:
                await websocket.send_json({
                    "type": "analogy", 
                    "chunk": "No valid analogy can be generated for this concept."
                    })
            await websocket.send_json({"type": "analogy_end"})
            
            
    except WebSocketDisconnect:
        print("WebSocket disconnected")
        return

if __name__ == "__main__":
    uvicorn.run("app:app", host="127.0.0.1", port=8000, reload=True)
