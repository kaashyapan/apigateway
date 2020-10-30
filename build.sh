#!/bin/sh
echo "Building the Docker image..."
docker build -t apigateway:latest .
docker tag apigateway:latest registry.gitlab.com/kaashyapan/apigateway:latest
docker push registry.gitlab.com/kaashyapan/apigateway:latest
echo "Pushed the docker image"
