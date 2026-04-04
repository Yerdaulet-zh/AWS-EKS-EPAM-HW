from fastapi import FastAPI
import redis
import os

app = FastAPI()

redis_host = os.getenv("REDIS_HOST", "redis")
r = redis.Redis(host=redis_host, port=6379)

@app.get("/")
def read_root():
    r.incr("counter")
    return {"counter": int(r.get("counter"))}
