"""Example test file demonstrating test structure."""

import pytest


class TestExample:
    """Example test class."""

    def test_addition(self):
        """Test basic addition."""
        assert 2 + 2 == 4

    def test_string_comparison(self):
        """Test string comparison."""
        assert "hello".upper() == "HELLO"

    @pytest.mark.skip(reason="Example of skipped test")
    def test_skipped_example(self):
        """This test is skipped."""
        pass


def test_simple_function():
    """Example of a simple function test."""

    def add(a, b):
        return a + b

    assert add(1, 2) == 3


@pytest.fixture
def sample_data():
    """Example fixture providing test data."""
    return {"key": "value", "number": 42}


def test_with_fixture(sample_data):
    """Example test using a fixture."""
    assert sample_data["key"] == "value"
    assert sample_data["number"] == 42
