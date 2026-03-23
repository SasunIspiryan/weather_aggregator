from flask import Flask
from app.routes.health import health_bp
from app.routes.crypto import crypto_bp

def create_app():
    app = Flask(__name__)

    # Register blueprints (modular routes)
    app.register_blueprint(health_bp)
    app.register_blueprint(crypto_bp)

    return app

