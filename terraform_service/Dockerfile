FROM hashicorp/terraform

WORKDIR /app/

# We need to copy the docker-entrypoint script to the container.
COPY ./docker-entrypoint ./docker-entrypoint

# We need to make the docker-entrypoint script executable.
RUN chmod +x ./docker-entrypoint

ENTRYPOINT ["./docker-entrypoint"]
