"""Tests for the main module."""

import pytest
from src.main import greet


class TestGreet:
    """Test cases for the greet function."""
    
    def test_greet_with_name(self):
        """Test greeting with a specific name."""
        result = greet("Alice")
        assert result == "Hello, Alice! Welcome to AriannesNetworks - Personality Network Analysis."
    
    def test_greet_without_name(self):
        """Test greeting without a name."""
        result = greet()
        assert result == "Hello! Welcome to AriannesNetworks - Personality Network Analysis."
    
    def test_greet_with_none(self):
        """Test greeting with None as name."""
        result = greet(None)
        assert result == "Hello! Welcome to AriannesNetworks - Personality Network Analysis."
