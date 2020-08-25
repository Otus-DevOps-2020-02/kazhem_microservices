#!/bin/bash
set -eu
# Собираем образ
docker build -t $USER_NAME/alertmanager .
