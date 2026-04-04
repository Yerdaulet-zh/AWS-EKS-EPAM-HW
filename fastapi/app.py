from fastapi import FastAPI, Form
from fastapi.responses import HTMLResponse, RedirectResponse
from prometheus_fastapi_instrumentator import Instrumentator
import redis
import os

app = FastAPI()
Instrumentator().instrument(app).expose(app)

redis_host = os.getenv("REDIS_HOST", "localhost")
r = redis.Redis(host=redis_host, port=6379, decode_responses=True)

@app.get("/", response_class=HTMLResponse)
async def read_root():
    tasks = r.lrange("todo_list", 0, -1)

    # Simple UI using Tailwind CSS
    tasks_html = "".join([f"<li class='bg-gray-50 p-3 mb-2 rounded border-l-4 border-blue-500 shadow-sm'>{task}</li>" for task in tasks])

    html_content = f"""
    <!DOCTYPE html>
    <html>
        <head>
            <title>Redis To-Do App</title>
            <script src="https://cdn.tailwindcss.com"></script>
        </head>
        <body class="bg-slate-100 min-h-screen flex items-center justify-center">
            <div class="bg-white p-8 rounded-xl shadow-2xl w-full max-w-md">
                <h1 class="text-3xl font-extrabold text-gray-800 mb-6 flex justify-between">
                    To-Do List
                    <span class="text-sm bg-blue-100 text-blue-600 py-1 px-3 rounded-full">{len(tasks)} tasks</span>
                </h1>

                <form action="/add" method="post" class="flex mb-6">
                    <input type="text" name="task" required placeholder="What needs to be done?"
                           class="flex-1 border border-gray-300 rounded-l-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-400">
                    <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold px-6 rounded-r-lg transition">
                        Add
                    </button>
                </form>

                <ul class="mb-6">
                    {tasks_html or '<p class="text-gray-400 italic text-center">No tasks yet. Add one above!</p>'}
                </ul>

                <div class="flex justify-between items-center border-t pt-4">
                    <p class="text-xs text-gray-400 font-mono">Connected to: {redis_host}</p>
                    <form action="/clear" method="post">
                        <button type="submit" class="text-red-500 hover:text-red-700 text-sm font-semibold">
                            Clear All
                        </button>
                    </form>
                </div>
            </div>
        </body>
    </html>
    """
    return HTMLResponse(content=html_content)

@app.post("/add")
async def add_task(task: str = Form(...)):
    if task.strip():
        r.lpush("todo_list", task.strip())
    return RedirectResponse(url="/", status_code=303)

@app.post("/clear")
async def clear_tasks():
    r.delete("todo_list")
    return RedirectResponse(url="/", status_code=303)
