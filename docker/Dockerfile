FROM ubuntu:22.04 as neovim-builder
RUN apt-get update && apt-get -y upgrade && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends \
    #fonts-powerline ninja-build gettext cmake unzip curl libuv1-dev libtermkey-dev luajit lua-lpeg libmsgpack-dev libtree-sitter-dev apt-transport-https ca-certificates git \
    fonts-powerline ninja-build gettext cmake unzip curl \
    #fzf \ #gonna install from git script for most up to date version
    ripgrep tree xclip \
    python3 python3-pip tzdata libtool libtool-bin autoconf automake gcc g++ \
    pkg-config zip unzip apt-transport-https ca-certificates git ssh luarocks \
    build-essential libuv1-dev libtermkey-dev luajit lua-lpeg libmsgpack-dev \
    libtree-sitter-dev tmux python3 python3-dev xdg-utils rustc cargo \
    nodejs npm clang mercurial gnupg \
    golang-go debian-keyring debian-archive-keyring fd-find gdb \
    #file less findutils ripgrep fd \
  && apt-get update && apt-get -y upgrade

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& apt update \
&& apt install gh -y

RUN npm i -g n && n stable

RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y caddy

RUN npm install -g yarn

RUN mkdir -m 700 /root/.ssh; \
  touch /root/.ssh/known_hosts; \
  ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts

RUN luarocks install lua_cliargs
RUN luarocks install luafilesystem
RUN luarocks install dkjson
RUN luarocks install say
RUN luarocks install luassert
RUN luarocks install lua-term
RUN luarocks install penlight
RUN luarocks install mediator_lua

ARG VIM=$PWD/neovim
ENV VIM $VIM

ARG VIM_INSTALL_PATH=$HOME/.config/nvim
ENV VIM_INSTALL_PATH $VIM_INSTALL_PATH

ARG VIMRUNTIME=/usr/share/nvim/runtime
ENV VIMRUNTIME $VIMRUNTIME

RUN git clone https://github.com/neovim/neovim.git \
    && cd neovim \
    && git checkout stable \
    && make CMAKE_BUILD_TYPE=RelWithDebInfo \
    && cd build && cpack -G DEB && dpkg -i nvim-linux64.deb

# unibilium
#RUN git clone https://github.com/mauke/unibilium.git \
#    && cd unibilium && make && cd .. && rm -r unibilium

RUN echo "set -g mouse on" > /etc/tmux.conf \
    && mkdir -p /run/tmux

RUN pip3 install pynvim black isort

RUN npm install -g typescript
RUN npm install -g neovim
RUN npm install -g @fsouza/prettierd
RUN npm install -g tree-sitter-cli
RUN npm install -g pyright
RUN npm install -g yaml-language-server
RUN npm install -g bash-language-server


FROM ubuntu:22.04
COPY --from=neovim-builder / /

# Set image locale.
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TZ=America/New_York

# perm vim user
ARG USER=david-engelmann
ENV USER $USER
RUN useradd -m -s /bin/bash $USER
RUN echo $USER "ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN cat /etc/sudoers

ARG HOME=/home/$USER
ENV HOME $HOME

ARG VIM=$PWD/neovim
ENV VIM $VIM

ARG VIM_INSTALL_PATH=$HOME/.config/nvim
ENV VIM_INSTALL_PATH $VIM_INSTALL_PATH

ARG VIMRUNTIME=/usr/share/nvim/runtime
ENV VIMRUNTIME $VIMRUNTIME

ARG SRC_ACCESS_TOKEN=my-token
ENV SRC_ACCESS_TOKEN $SRC_ACCESS_TOKEN

ARG SRC_ENDPOINT=http://localhost
ENV SRC_ENDPOINT $SRC_ENDPOINT

#RUN adduser $USER && \
#    usermod -aG sudo $USER; \

# COPY OVER CONFIG
COPY --chown=$USER --chmod=0644 config* $HOME/.config/nvim/
COPY --chown=$USER --chmod=0644 . $HOME

RUN git clone --depth 1 https://github.com/mauke/fzf.git $HOME/.fzf \
    && $HOME/.fzf/install

COPY docker/scripts/julia_install.sh .
RUN sh julia_install.sh

RUN ls -a /home/$USER/.config/nvim

USER ${USER:-david-engelmann}
ARG SRC_ACCESS_TOKEN=my-token
ENV SRC_ACCESS_TOKEN $SRC_ACCESS_TOKEN

ARG SRC_ENDPOINT=http://localhost
ENV SRC_ENDPOINT $SRC_ENDPOINT

WORKDIR $HOME
COPY . .
ENV PATH="$VIM_INSTALL_PATH/bin:$VIMRUNTIME/bin:$VIM/bin:$PATH"
RUN nvim --headless "+Lazy! sync" +qa
RUN nvim --headless "TSUpdate" +qa
