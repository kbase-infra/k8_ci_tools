FROM ghcr.io/astral-sh/uv:0.12.17@sha256:10787c682e4184e4f290de1171fd4703dc63de99221f10fe1c99002ce7fa9acc AS uv

FROM alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

RUN apk add --no-cache \
    curl \
    tar \
    gzip \
    git \
    bash

# --- Install uv and latest Python ---
COPY --from=uv /uv /uvx /usr/local/bin/
ENV UV_PYTHON_INSTALL_DIR=/opt/python \
    UV_PYTHON_PREFERENCE=only-managed
RUN uv python install --default --preview && \
    ln -sf "$(uv python find)" /usr/local/bin/python3

# --- Install Kube-linter ---
ARG KUBELINTER_VERSION="v0.8.3"
RUN curl -sSL "https://github.com/stackrox/kube-linter/releases/download/${KUBELINTER_VERSION}/kube-linter-linux" -o /usr/local/bin/kube-linter && \
    chmod +x /usr/local/bin/kube-linter

# --- Install Kustomize ---
ARG KUSTOMIZE_VERSION="5.8.1"
RUN curl -sSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" | tar xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/kustomize

ENTRYPOINT ["/bin/bash"]
