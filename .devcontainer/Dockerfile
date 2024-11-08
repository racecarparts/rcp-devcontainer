# Dockerfile
FROM alpine:latest

ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
ARG GO_VERSION
ARG PYTHON_VERSION
ARG ARCHITECTURE

# Set environment variables
ENV GIT_USER_NAME=${GIT_USER_NAME}
ENV GIT_USER_EMAIL=${GIT_USER_EMAIL}
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

RUN echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories

# Install base packages and font dependencies
RUN apk update && apk add --no-cache \
    nano \
    git \
    openssh \
    curl \
    bash \
    zsh \
    zsh-vcs \
    wget \
    gcc \
    musl-dev \
    libc-dev \
    make \
    py3-pip \
    build-base \
    fontconfig \
    shadow \
    openssl-dev \
    bzip2-dev \
    zlib-dev \
    readline-dev \
    sqlite-dev \
    linux-headers \
    xz-dev \
    tk-dev \
    nodejs \
    npm \
    postgresql-dev \
    libffi

RUN git config --global user.name "$GIT_USER_NAME" \
    && git config --global user.email "$GIT_USER_EMAIL" 

# Copy the .gitconfig and global .gitignore into the container
COPY .devcontainer/git-cfg/.gitconfig /root/.gitconfig
COPY .devcontainer/git-cfg/.gitignore_global /root/.gitignore_global

# Set the global Git ignore file
RUN git config --global core.excludesFile /root/.gitignore_global

# Install pyenv to manage Python versions
RUN curl https://pyenv.run | bash

# Add pyenv to the shell path
ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:/root/.pyenv/bin:$PATH"
RUN echo 'export PATH="/root/.pyenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Install the specific Python version
RUN echo python version: $PYTHON_VERSION
RUN pyenv install $PYTHON_VERSION && \
    pyenv global $PYTHON_VERSION
RUN pip install --no-cache-dir --upgrade pip setuptools pre-commit black flake8 debugpy

# Install Go
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-${ARCHITECTURE}.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-${ARCHITECTURE}.tar.gz && \
    rm go${GO_VERSION}.linux-${ARCHITECTURE}.tar.gz

# Download and install Source Code Pro from Google Fonts API
RUN mkdir -p /usr/share/fonts/source-code-pro && \
    wget -qO /usr/share/fonts/source-code-pro/SourceCodePro-Regular.ttf \
    "https://fonts.googleapis.com/css2?family=Source+Code+Pro:wght@400;700&display=swap" && \
    fc-cache -f -v

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k theme
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k

# Install Zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Configure Zsh with Powerlevel10k theme and plugins
COPY .devcontainer/p10k-cfg/.p10k.zsh /root/.p10k.zsh
RUN echo "source /root/powerlevel10k/powerlevel10k.zsh-theme" >> /root/.zshrc && \
    echo "[ -f /root/.p10k.zsh ] && source /root/.p10k.zsh" >> /root/.zshrc && \
    echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> /root/.zshrc && \
    echo "source /root/.oh-my-zsh/oh-my-zsh.sh" >> /root/.zshrc

# Set the working directory
WORKDIR /workspace

COPY .devcontainer/post-create-scripts /tmp/post-create-scripts

# Set Zsh as the default shell on container start
CMD ["zsh"]
