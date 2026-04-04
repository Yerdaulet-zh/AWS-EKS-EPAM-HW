from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from prometheus_fastapi_instrumentator import Instrumentator
import redis
import os

app = FastAPI()
Instrumentator().instrument(app).expose(app)

redis_host = os.getenv("REDIS_HOST", "redis")
r = redis.Redis(host=redis_host, port=6379, decode_responses=True)

@app.get("/", response_class=HTMLResponse)
async def read_root():
    # Get current value (default to 0 if not set)
    count = r.get("counter") or 0

    html_content = f"""
    <!DOCTYPE html>
    <html>
        <head>
            <title>FastAPI + Redis</title>
            <script src="https://cdn.tailwindcss.com"></script>
        </head>
        <body class="bg-gray-100 h-screen flex items-center justify-center">
            <div class="bg-white p-8 rounded-lg shadow-xl text-center w-96">
                <h1 class="text-2xl font-bold text-gray-800 mb-4">Redis Counter</h1>
                <div class="text-6xl font-extrabold text-blue-600 mb-6" id="count-display">
                    {count}
                </div>
                <button onclick="incrementCounter()"
                    class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-full transition duration-300 ease-in-out transform hover:scale-105 shadow-md">
                    Incriment Counter
                </button>
                <p class="mt-4 text-sm text-gray-500">Connected to: <span class="font-mono">{redis_host}</span></p>
            </div>

            <script>
                async function incrementCounter() {{
                    const response = await fetch('/increment', {{ method: 'POST' }});
                    const data = await response.json();
                    document.getElementById('count-display').innerText = data.counter;
                }}
            </script>
        </body>
    </html>
    """
    return HTMLResponse(content=html_content)

@app.post("/increment")
async def increment():
    new_count = r.incr("counter")
    return {"counter": new_count}