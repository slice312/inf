FROM ubuntu:latest

# Установите Git
RUN apt-get update && apt-get install -y git && apt-get clean
