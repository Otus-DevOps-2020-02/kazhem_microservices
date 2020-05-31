FROM python:3.6.0-alpine

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts
ENV APP_HOME /app


WORKDIR $APP_HOME

# Install requiremets (fat layer)
COPY requirements.txt ${APP_HOME}/
RUN apk add --no-cache --virtual .build-deps build-base && \
    pip install --no-cache-dir -r ${APP_HOME}/requirements.txt && \
    apk del build-base

# Application (frequently changing layer)
COPY . $APP_HOME/

ENTRYPOINT ["python3"]
CMD ["post_app.py"]
