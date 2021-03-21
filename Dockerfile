FROM alpine:3.13

RUN apk add --no-cache rsync
COPY entrypoint.sh /entrypoint.sh

EXPOSE 873

CMD ["/entrypoint.sh"]
