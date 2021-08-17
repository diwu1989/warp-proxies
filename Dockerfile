ARG DEBIAN_RELEASE=buster
FROM docker.io/debian:$DEBIAN_RELEASE-slim
ARG DEBIAN_RELEASE
COPY cloudflare.gpg /
ENV DEBIAN_FRONTEND noninteractive
RUN true && \
	apt update && \
	apt install -y gnupg ca-certificates libcap2-bin haproxy tini && \
	apt-key add /cloudflare.gpg && \
	echo "deb http://pkg.cloudflareclient.com/ $DEBIAN_RELEASE main" > /etc/apt/sources.list.d/cloudflare-client.list && \
	apt update && \
	apt install cloudflare-warp -y && \
	apt clean -y
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
EXPOSE 40000/tcp
CMD ["tini", "--", "/entrypoint.sh"]
