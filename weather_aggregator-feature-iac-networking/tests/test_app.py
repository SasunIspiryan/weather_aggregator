"""
Simple tests for the Weather Aggregator app.
"""

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
