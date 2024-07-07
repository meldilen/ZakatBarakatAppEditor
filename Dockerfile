FROM ghcr.io/cirruslabs/flutter:latest

RUN apt update && apt install --no-install-recommends -y nginx && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["nginx", "-g", "daemon off;"]
