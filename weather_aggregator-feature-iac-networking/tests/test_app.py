"""
Simple tests for the Weather Aggregator app.
"""

import importlib.util
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))


def test_basic_arithmetic():
    """Trivial test to ensure test framework works."""
    assert 1 + 1 == 2


def test_imports():
    """Test that core dependencies can be imported."""
    try:
        from flask import Flask
        from requests import get
        from flask_sqlalchemy import SQLAlchemy
        assert True
    except ImportError as e:
        assert False, f"Import failed: {e}"


def test_app_creation():
    """Test that the Flask app can be instantiated."""
    try:
        from app import app
        assert app is not None
        assert app.name == "app"
    except Exception as e:
        assert False, f"App creation failed: {e}"


def test_metrics_endpoint():
    """The app should expose a Prometheus metrics endpoint."""
    from app import app

    client = app.test_client()
    response = client.get("/metrics")

    assert response.status_code == 200
    assert b"http_requests_total" in response.data
