from flask import Flask
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)
VISITS = Counter("visits_total", "Total visits")

@app.get("/")
def hello():
    VISITS.inc()
    return "Hello from DevOps Lab!\n"

@app.get("/metrics")
def metrics():
    return generate_latest(), 200, {"Content-Type": CONTENT_TYPE_LATEST}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
