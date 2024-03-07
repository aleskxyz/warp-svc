FROM ubuntu:22.04
ENV WARP_LICENSE=
ENV FAMILIES_MODE=off
EXPOSE 1080/tcp
RUN apt-get update && \
  apt-get install curl gpg socat lsb-release -y && \
  curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflare-client.list && \
  apt-get update && \
  apt-get install cloudflare-warp -y && \
  rm -rf /var/lib/apt/lists/*
COPY --chmod=755 entrypoint.sh entrypoint.sh
VOLUME ["/var/lib/cloudflare-warp"]
CMD ["./entrypoint.sh"]