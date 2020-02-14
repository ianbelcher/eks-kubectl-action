FROM python:3.7-alpine3.9

LABEL maintainer="Ian Belcher <github.com@ianbelcher.me>"

ENV PATH="/root/.local/bin:$PATH"
ENV PYTHONIOENCODING=UTF-8

RUN apk add --no-cache curl

RUN pip install --user awscli
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl