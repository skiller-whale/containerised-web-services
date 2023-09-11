FROM python:3.11

RUN python -m pip install requests~=2.31.0

WORKDIR /app/

COPY . .

# # For testing without the API
# RUN python -m pip install responses

CMD ["python3", "credential_service.py"]
