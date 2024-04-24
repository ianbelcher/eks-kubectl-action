FROM python:3.13.0a6-alpine

LABEL maintainer="Ian Belcher <github.com@ianbelcher.me>"

ENV PYTHONIOENCODING=UTF-8

RUN apk add --no-cache curl aws-cli

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
