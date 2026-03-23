from flask import Flask, jsonify, render_template
import requests
import os

app = Flask(__name__)

@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "healthy", "version": "1.0.0"})

API_KEY = os.getenv("API_KEY", "default_key")

@app.route("/api/v1/crypto", methods=["GET"])
def crypto_data():
    url = "https://api.coingecko.com/api/v3/simple/price"
    params = {
        "ids": "bitcoin,ethereum,cardano",
        "vs_currencies": "usd"
    }

    try:
        response = requests.get(url, params=params, timeout=5)
        response.raise_for_status()
        data = response.json()

        btc_price = data["bitcoin"]["usd"]
        eth_price = data["ethereum"]["usd"]
        ada_price = data["cardano"]["usd"]
        eth_btc_ratio = round(eth_price / btc_price, 4)

        return jsonify({
            "bitcoin_usd": btc_price,
            "ethereum_usd": eth_price,
            "cardano_usd": ada_price,
            "eth_btc_ratio": eth_btc_ratio,
            "environment": os.getenv("APP_ENV", "development")
        })
    except requests.exceptions.RequestException as e:
        return jsonify({"error": str(e)}), 500

# 👇 New frontend route
@app.route("/")
def index():
    return render_template("index.html")

if __name__ == "__main__":
    app.run(debug=True)
