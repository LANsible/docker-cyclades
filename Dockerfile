ARG ARCHITECTURE
#######################################################################################################################
# Install of cyclades binary
#######################################################################################################################
FROM multiarch/ubuntu-debootstrap:${ARCHITECTURE}-bionic as builder

RUN echo "deb http://archive.ubuntu.com/ubuntu bionic universe" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install cyclades-serial-client busybox-static

#######################################################################################################################
# Final scratch image
#######################################################################################################################
FROM scratch

# Add default configuration
COPY examples/config/cyclades-devices /etc/cyclades-devices

# Needs shell otherwise wont start
COPY --from=builder /bin/busybox /bin/sh

# Add binary
COPY --from=builder /usr/sbin/cyclades-serial-client /usr/sbin/cyclades-serial-client

ENTRYPOINT ["/usr/sbin/cyclades-serial-client"]
