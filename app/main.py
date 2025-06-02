from fastapi import FastAPI, Response
from fastapi.responses import RedirectResponse
import os

app = FastAPI()

@app.get("/")
async def root():
    port = os.getenv("PORT", "3000")
    return RedirectResponse(url=f"/grafana")

@app.get("/health")
async def health_check():
    return {"status": "healthy"} 