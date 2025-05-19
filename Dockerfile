FROM alpine:3.21.3

RUN apk add --no-cache \
    curl \
    tar \
    gzip \
    git \
    bash # Adding bash for more robust scripting capabilities in your CI jobs

# --- Install Kube-linter ---
ARG KUBELINTER_VERSION="v0.7.2"
RUN curl -sSL "https://github.com/stackrox/kube-linter/releases/download/${KUBELINTER_VERSION}/kube-linter-linux" -o /usr/local/bin/kube-linter && \
    chmod +x /usr/local/bin/kube-linter

# --- Install Kustomize ---
ARG KUSTOMIZE_VERSION="5.6.0"
RUN curl -sSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" | tar xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/kustomize

ENTRYPOINT ["/bin/bash"]
