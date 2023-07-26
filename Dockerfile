FROM python:3.10.0a7-alpine3.13

LABEL maintainer="Ian Belcher <github.com@ianbelcher.me>"

ENV PYTHONIOENCODING=UTF-8

RUN apk add --no-cache curl jq

RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
