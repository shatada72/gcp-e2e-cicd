import pytest
from app import app

def test_hello():
    client = app.test_client()

    response = client.get("/")

    assert (response.status_code == 200)
    assert ("TecHub" in str(response.data))

