import responses
import credential_service

# You can run this test locally if you have Python > 3.10 and responses installed.
# or you can modify the Dockerfile to install responses and run it with docker compose up --build

AWS_DIRECTORY = '.' # Change to /root/aws if you're running this in Docker
API_URL = 'https://train.skillerwhale.com/aws/attendances/test-attendance-id/account_allocations'

@responses.activate
def test_success():
    responses.add(responses.POST, API_URL,
                json={
      "account_allocation": {
        "console_link": "https://signin.aws.amazon.com/federation...",
        "aws_account_number": "1122334455",
        "credentials": {
          "access_key_id": "test",
          "secret_access_key": "test",
          "session_token":  "test"
        }
      }
    }, status=200)

    assert credential_service.main(AWS_DIRECTORY)

@responses.activate
def test_forbidden():
    responses.add(responses.POST, API_URL, status=403)

    assert not credential_service.main(AWS_DIRECTORY)

@responses.activate
def test_500():
    responses.add(responses.POST, API_URL, status=500)

    assert not credential_service.main(AWS_DIRECTORY)

if __name__ == '__main__':
    test_success()
    test_forbidden()
    test_500()
