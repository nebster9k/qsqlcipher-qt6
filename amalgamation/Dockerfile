FROM debian:bookworm-slim

ARG SQLCIPHER_VERSION=v4.18.0

RUN apt-get update && apt-get install -y --no-install-recommends \
        git ca-certificates build-essential tcl-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git config --system user.email "build@localhost" \
 && git config --system user.name  "amalgamation builder" \
 && git config --system --add safe.directory /work

WORKDIR /work
RUN git clone --depth 1 https://github.com/chehrlic/sqlcipher-amalgamation.git .

RUN sed -i "s|^version=.*|version=${SQLCIPHER_VERSION}|" create_amalgamation.sh \
 && chmod +x create_amalgamation.sh \
 && grep '^version=' create_amalgamation.sh

CMD ["/bin/bash"]