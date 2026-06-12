FROM debian:bookworm-slim
 
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8
 
# ---- Pacotes base + dependências de build para o asdf compilar versões ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    ca-certificates \
    ripgrep \
    build-essential \
    python3 \
    python3-pip \
    bash \
    micro \
    bat \
    sudo \
    unzip \
    # deps comuns para compilar runtimes via asdf (node, ruby, python, etc.)
    autoconf \
    libssl-dev \
    zlib1g-dev \
    libreadline-dev \
    libbz2-dev \
    libsqlite3-dev \
    libffi-dev \
    libxml2-dev \
    libxmlsec1-dev \
    liblzma-dev \
    libncurses-dev \
    && rm -rf /var/lib/apt/lists/*
 
# ---- Usuário não-root (sem grupo docker — não há socket aqui) ----
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000
 
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}
 
USER ${USERNAME}
ENV HOME=/home/${USERNAME}
 
# ---- asdf (v0.16+, binário em Go) ----
ARG ASDF_VERSION=v0.19.0
RUN ARCH="$(dpkg --print-architecture)" \
    && case "${ARCH}" in \
         amd64) ASDF_ARCH="amd64" ;; \
         arm64) ASDF_ARCH="arm64" ;; \
         *) echo "Arquitetura nao suportada: ${ARCH}" && exit 1 ;; \
       esac \
    && curl -fsSL "https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-linux-${ASDF_ARCH}.tar.gz" \
        -o /tmp/asdf.tar.gz \
    && mkdir -p ${HOME}/.local/bin \
    && tar -xzf /tmp/asdf.tar.gz -C ${HOME}/.local/bin asdf \
    && rm /tmp/asdf.tar.gz
 
ENV ASDF_DATA_DIR=${HOME}/.asdf
ENV PATH=${HOME}/.local/bin:${ASDF_DATA_DIR}/shims:${HOME}/.npm-global/bin:${PATH}

# ---- Instala node usando asdf pro claude ----
RUN asdf plugin add nodejs && \
    asdf install nodejs 24.16.0 && \
    asdf set --home nodejs 24.16.0

# ---- Claude Code (no Node gerenciado pelo asdf, prefixo no HOME, sem root) ----
RUN npm config set prefix ${HOME}/.npm-global \
    && npm install -g @anthropic-ai/claude-code \
    && asdf reshim nodejs

# ---- Copia o entrypoint custom ----
COPY --chown=${USER_UID}:${USER_GID} entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sudo chmod +x /usr/local/bin/entrypoint.sh
 
WORKDIR /workspace
 
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]