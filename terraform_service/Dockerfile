FROM hashicorp/terraform

WORKDIR /app/

COPY ./docker-entrypoint ./docker-entrypoint
RUN chmod +x ./docker-entrypoint

COPY ./setup ./setup
RUN chmod +x ./setup

#Allows us to do `docker compose exec terraform setup` rather than `docker compose exec terraform ./setup`, which looks slightly cleaner
ENV PATH=$PATH:/app

ENTRYPOINT ["./docker-entrypoint"]
