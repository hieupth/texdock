FROM texlive/texlive:latest

LABEL maintainer="hieupth"
LABEL description="TeX Live full installation with tlmgr for texdock"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        fonts-noto \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /texdock/input /texdock/output

COPY entrypoint.sh /texdock/entrypoint.sh
RUN chmod +x /texdock/entrypoint.sh

WORKDIR /texdock/input

ENTRYPOINT ["/texdock/entrypoint.sh"]
