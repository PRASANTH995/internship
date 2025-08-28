from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/", methods=["GET"])
def home():
    return jsonify(message="Hello from Flask CI/CD!"), 200


@app.route("/status", methods=["GET"])
def status():
    return jsonify(status="ok", version="1.0.0"), 200


@app.route("/healthz", methods=["GET"])
def health():
    # Add real checks here (DB, cache, etc.) in a real app
    return jsonify(healthy=True), 200


if __name__ == "__main__":
    # Dev server; in containers you may prefer gunicorn for prod-like usage
    app.run(host="0.0.0.0", port=5000)
