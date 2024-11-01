# Setup
FROM alpine as setup
RUN addgroup --system appgroup --gid 1111 && \
    adduser -S appuser --ingroup appgroup --uid 1111

# Development image
FROM busybox as nginx-default-backend-dbg
COPY --from=setup /etc/passwd /etc/passwd
COPY nginx-default-backend /bin/
USER appuser
EXPOSE 1234
ENTRYPOINT ["/bin/nginx-default-backend"]

# Production image
FROM scratch as nginx-default-backend
COPY --from=setup /etc/passwd /etc/passwd
COPY nginx-default-backend /bin/
USER appuser
EXPOSE 1234
ENTRYPOINT ["/bin/nginx-default-backend"]
