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
COPY examples/compose/config/cyclades-devices /etc/cyclades-devices

# Needs shell otherwise wont start
COPY --from=builder /bin/busybox /bin/sh

# Add binary
COPY --from=builder /usr/sbin/cyclades-serial-client /usr/sbin/tsrsock

# Add library
# COPY --from=builder /usr/lib/libcyclades-ser-cli.so /usr/lib/libcyclades-ser-cli.so

ENTRYPOINT ["/usr/sbin/tsrsock"]
