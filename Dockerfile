# Setup
FROM alpine:3.20 as setup
RUN addgroup --gid 10000 -S appgroup && \
    adduser --uid 10000 -S appuser -G appgroup

FROM scratch
COPY --from=setup /etc/passwd /etc/passwd
COPY 404 /404
USER appuser
EXPOSE 1234
ENTRYPOINT ["/404"]
