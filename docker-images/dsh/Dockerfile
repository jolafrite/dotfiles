FROM node:24-slim

ARG TARGETARCH

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    ca-certificates \
    curl \
    gh \
    yadm \
    unzip \
    zip \
    zsh \
    build-essential \
    libssl-dev \
    libcurl4-openssl-dev \
    libexpat1-dev \
    zlib1g-dev \
    gettext \
    libtool \
    pkg-config \
  && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal \
  && rm -rf /root/.cargo/registry/cache /root/.rustup/tmp
ENV PATH="/root/.cargo/bin:${PATH}"

RUN GIT_VERSION=$(curl -fsSL https://api.github.com/repos/git/git/tags \
      | grep -oE '"name": "v[0-9.]+"' | head -1 | cut -d'"' -f4) \
  && echo "Building git ${GIT_VERSION}" \
  && curl -fsSL --retry 3 --retry-delay 2 --max-time 180 -o /tmp/git.tar.gz "https://github.com/git/git/archive/refs/tags/${GIT_VERSION}.tar.gz" \
  && tar -xzf /tmp/git.tar.gz -C /tmp \
  && cd "/tmp/git-${GIT_VERSION#v}" \
  && make -j"$(nproc)" prefix=/usr/local NO_TCLTK=1 \
  && make prefix=/usr/local install \
  && cd / && rm -rf /tmp/git-* /tmp/git.tar.gz

RUN JJ_ARCH=$([ "$TARGETARCH" = "amd64" ] && echo "x86_64" || echo "aarch64") \
  && JJ_VERSION=$(curl -fsSL https://api.github.com/repos/jj-vcs/jj/tags | grep -oE '"name": "v[0-9.]+"' | head -1 | cut -d'"' -f4) \
  && curl -fsSL -o /tmp/jj.tar.gz "https://github.com/jj-vcs/jj/releases/download/${JJ_VERSION}/jj-${JJ_VERSION}-${JJ_ARCH}-unknown-linux-musl.tar.gz" \
  && tar -C /usr/local/bin --strip-components=1 -xzf /tmp/jj.tar.gz \
  && rm /tmp/jj.tar.gz

ENV SDKMAN_DIR=/root/.sdkman
RUN curl -s "https://get.sdkman.io" | bash \
  && chmod +x "$SDKMAN_DIR/bin/sdkman-init.sh" \
  && bash -c "source \"$SDKMAN_DIR/bin/sdkman-init.sh\" && sdk install java && sdk install kotlin" \
  && rm -rf "$SDKMAN_DIR"/tmp "$SDKMAN_DIR"/archives "$SDKMAN_DIR"/var/tmp
ENV PATH="${SDKMAN_DIR}/bin:${PATH}"

ENV PNPM_HOME=/home/dsh/.local/share/pnpm
ENV PATH="${PNPM_HOME}/bin:${PATH}"
RUN npm install -g npm@latest pnpm

RUN CF_ARCH=$([ "$TARGETARCH" = "amd64" ] && echo "amd64" || echo "arm64") \
  && CF_VERSION=$(curl -fsSL https://api.github.com/repos/cloudflare/cloudflared/tags | grep -oE '"name": "[^"]+"' | head -1 | cut -d'"' -f4) \
  && curl -fsSL -o /usr/local/bin/cloudflared "https://github.com/cloudflare/cloudflared/releases/download/${CF_VERSION}/cloudflared-linux-${CF_ARCH}" \
  && chmod +x /usr/local/bin/cloudflared

RUN NVIM_ARCH=$([ "$TARGETARCH" = "amd64" ] && echo "x86_64" || echo "arm64") \
  && curl -fsSL -o /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-${NVIM_ARCH}.tar.gz" \
  && tar -C /usr/local -xzf /tmp/nvim.tar.gz \
  && rm /tmp/nvim.tar.gz
ENV PATH="/usr/local/nvim-linux-${TARGETARCH:-arm64}/bin:${PATH}"

RUN useradd -m -s /bin/zsh dsh \
  && echo "dsh ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dsh \
  && chmod 0440 /etc/sudoers.d/dsh \
  && mkdir -p /home/dsh/.dsh /home/dsh/.cloudflared /home/dsh/.local/share/pnpm \
  && chown -R dsh:dsh /home/dsh

COPY .dsh-context/ /home/dsh/.dsh/
COPY entrypoint.sh /usr/local/bin/dsh-entrypoint.sh

RUN chmod +x /usr/local/bin/dsh-entrypoint.sh \
  && chown -R dsh:dsh /home/dsh/.cloudflared \
  && chown -R dsh:dsh /home/dsh/.dsh

ENV DSH_HOME=/home/dsh/.dsh

RUN echo "========================================" \
  && echo "🔍 Dependency Version Checks:" \
  && echo "  • Git:        $(git --version)" \
  && echo "  • Rust:       $(rustc --version)" \
  && echo "  • Cargo:      $(cargo --version)" \
  && echo "  • Node:       $(node --version)" \
  && echo "  • NPM:        $(npm --version)" \
  && echo "  • PNPM:       $(pnpm --version)" \
  && echo "  • Neovim:     $(nvim --version | head -n 1)" \
  && echo "  • Cloudflared: $(cloudflared --version)" \
  && echo "  • GH CLI:     $(gh --version | head -n 1)" \
  && echo "  • Yadm:       $(yadm version 2>&1 | grep -o 'yadm version [0-9.]*')" \
  && echo "  • Jujutsu:    $(jj --version)" \
  && echo "  • Zsh:        $(zsh --version)" \
  && bash -c 'source "$SDKMAN_DIR/bin/sdkman-init.sh" && echo "  • SDKMAN:     $(sdk version)"' \
  && echo "  • Java:       $(java -version 2>&1 | head -n 1)" \
  && echo "  • Kotlin:     $(kotlinc -version 2>&1)" \
  && echo "========================================"

USER dsh
WORKDIR /home/dsh
EXPOSE 3080

RUN pnpm add -g \
  --allow-build=koffi --allow-build=node-pty --allow-build=protobufjs \
  --allow-build=@deepseek-ai/dsh-subprocess-local --allow-build=@google/genai \
  typescript @deepseek-ai/dsh@0.1.2-rc.1 @mnemon-dev/mnemon@0.2.8

ENTRYPOINT ["/usr/local/bin/dsh-entrypoint.sh"]
CMD ["dsh", "--profile", "web"]
