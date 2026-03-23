from flask import Blueprint, jsonify
import requests
import os

crypto_bp = Blueprint("crypto", __name__)

@crypto_bp.route("/api/v1/crypto", methods=["GET"])
def crypto_data():
    url = "https://api.coingecko.com/api/v3/simple/price"
    params = {"ids": "bitcoin,ethereum,cardano", "vs_currencies": "usd"}
    response = requests.get(url, params=params)

    if response.status_code == 200:
        data = response.json()
        btc = data["bitcoin"]["usd"]
        eth = data["ethereum"]["usd"]
        ada = data["cardano"]["usd"]
        ratio = round(eth / btc, 4)

        return jsonify({
            "bitcoin_usd": btc,
            "ethereum_usd": eth,
            "cardano_usd": ada,
            "eth_btc_ratio": ratio,
            "environment": os.getenv("APP_ENV", "development")
        })
    else:
        return jsonify({"error": "Unable to fetch crypto data"}), 500

