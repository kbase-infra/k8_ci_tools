FROM alpine:3.24.2

RUN apk add --no-cache \
    curl \
    tar \
    gzip \
    git \
    bash

# --- Install uv and latest Python ---
ARG UV_VERSION="0.12.17"
COPY --from=ghcr.io/astral-sh/uv:${UV_VERSION} /uv /uvx /usr/local/bin/
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
