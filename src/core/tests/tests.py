import pytest
from pytest_factoryboy import register
from factories import UserFactory
from django.urls import reverse
from utils.logger import LogLevel, console_logger
from django.contrib.messages import get_messages

register(UserFactory)
CONSOLE = console_logger(name="tests_core", level=LogLevel.DEBUG)


@pytest.mark.django_db
def test_login_with_email(client, user_factory):
    user = user_factory.create(password="teste123")
    login_data = {"username": user.email, "password": "test123"}
    response = client.post(reverse("login"), data=login_data)

    assert response.status_code == 302


@pytest.mark.django_db
def test_login_with_email_incorrect(client):
    login_data = {"username": "email123@teste.com", "password": "teste123!"}
    response = client.post(reverse("login"), data=login_data)
    messages = list(get_messages(response.wsgi_request))

    assert any("Usuário ou senha inválidos." in str(m) for m in messages)
    assert response.status_code == 302
