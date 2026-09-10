FROM node:24-slim

ARG TARGETARCH

ARG GIT_VERSION=v2.55.0
ARG JJ_VERSION=v0.45.1
ARG CF_VERSION=2026.8.3

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    ca-certificates \
    curl \
    gh \
    yadm \
    unzip \
    zip \
    zsh \
    socat \
    ncurses-term \
    build-essential \
    libssl-dev \
    libcurl4-openssl-dev \
    libexpat1-dev \
    zlib1g-dev \
    gettext \
    libtool \
    pkg-config \
    cargo

RUN curl -fsSL -o /tmp/git.tar.gz "https://github.com/git/git/archive/refs/tags/${GIT_VERSION}.tar.gz" \
  && tar -xzf /tmp/git.tar.gz -C /tmp \
  && cd "/tmp/git-${GIT_VERSION#v}" \
  && mkdir -p t/helper/.depend \
  && make -j"$(nproc)" prefix=/usr/local NO_TCLTK=1 \
  && make prefix=/usr/local install \
  && cd / && rm -rf /tmp/git-* /tmp/git.tar.gz

# RUN JJ_ARCH=$([ "$TARGETARCH" = "amd64" ] && echo "x86_64" || echo "aarch64") \
#   && curl -fsSL -o /tmp/jj.tar.gz "https://github.com/jj-vcs/jj/releases/download/${JJ_VERSION}/jj-${JJ_VERSION}-${JJ_ARCH}-unknown-linux-musl.tar.gz" \
#   && tar -C /usr/local/bin --strip-components=1 -xzf /tmp/jj.tar.gz \
#   && rm /tmp/jj.tar.gz

# RUN CF_ARCH=$([ "$TARGETARCH" = "amd64" ] && echo "amd64" || echo "arm64") \
#   && curl -fsSL -o /usr/local/bin/cloudflared "https://github.com/cloudflare/cloudflared/releases/download/${CF_VERSION}/cloudflared-linux-${CF_ARCH}" \
#   && chmod +x /usr/local/bin/cloudflared

# RUN NVIM_ARCH=$([ "$TARGETARCH" = "amd64" ] && echo "x86_64" || echo "arm64") \
#   && curl -fsSL -o /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-${NVIM_ARCH}.tar.gz" \
#   && tar -C /usr/local -xzf /tmp/nvim.tar.gz \
#   && ln -s /usr/local/nvim-linux-${NVIM_ARCH} /usr/local/nvim \
#   && rm /tmp/nvim.tar.gz
# ENV PATH="/usr/local/nvim/bin:${PATH}"

# RUN npm install -g npm@latest pnpm

RUN useradd -m -s /bin/zsh dsh \
  && echo "dsh ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dsh \
  && chmod 0440 /etc/sudoers.d/dsh

# ENV RUSTUP_HOME=/home/dsh/.rustup
# ENV CARGO_HOME=/home/dsh/.cargo
# ENV PATH="/home/dsh/.cargo/bin:${PATH}"
# ENV SDKMAN_DIR=/home/dsh/.sdkman
# ENV PATH="${SDKMAN_DIR}/bin:${PATH}"
# ENV PNPM_HOME=/home/dsh/.local/share/pnpm
# ENV PATH="${PNPM_HOME}/bin:${PATH}"

# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal \
#   && rm -rf /home/dsh/.cargo/registry/cache /home/dsh/.rustup/tmp

# RUN curl -s "https://get.sdkman.io" | bash \
#   && chmod +x "$SDKMAN_DIR/bin/sdkman-init.sh" \
#   && bash -c "source \"$SDKMAN_DIR/bin/sdkman-init.sh\" && sdk install java && sdk install kotlin" \
#   && rm -rf "$SDKMAN_DIR"/tmp "$SDKMAN_DIR"/archives "$SDKMAN_DIR"/var/tmp

RUN mkdir -p \
  /home/dsh/.dsh \
  /home/dsh/.cloudflared \
  /home/dsh/.local/share/pnpm \
  /home/dsh/.local/share/yadm

COPY cloudflared/ /home/dsh/.cloudflared/
COPY .dsh-context/ /home/dsh/.dsh/
# Also keep a copy outside /home/dsh so it survives the dsh-home volume mount
COPY .dsh-context/ /usr/local/share/dsh-context/
COPY entrypoint.sh /usr/local/bin/dsh-entrypoint.sh

RUN pnpm add -g \
  --allow-build=koffi --allow-build=node-pty --allow-build=protobufjs \
  --allow-build=@deepseek-ai/dsh-subprocess-local --allow-build=@google/genai \
  typescript @deepseek-ai/dsh@latest @mnemon-dev/mnemon@0.2.8 9router

# C.UTF-8 is pre-built in node:24-slim; en_US.UTF-8 needs the full
# locales package which is slow to build. Patch env_config.zsh at runtime
# to use C.UTF-8 instead.

RUN apt-get purge -y --auto-remove \
  build-essential \
  libssl-dev \
  libcurl4-openssl-dev \
  libexpat1-dev \
  zlib1g-dev \
  gettext \
  libtool \
  pkg-config \
  && rm -rf /var/lib/apt/lists/*

RUN chmod +x /usr/local/bin/dsh-entrypoint.sh \
  && chown -R dsh:dsh /home/dsh

ENV LANG=C.UTF-8 \
    LANGUAGE=en_US \
    LC_CTYPE=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DSH_HOME=/home/dsh/.dsh

USER dsh
WORKDIR /home/dsh
EXPOSE 3080

ENTRYPOINT ["/usr/local/bin/dsh-entrypoint.sh"]
CMD ["dsh", "--profile", "web"]
