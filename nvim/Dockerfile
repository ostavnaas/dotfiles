FROM ubuntu:jammy

RUN \
  apt-get update && \
  apt-get install -y git ninja-build gettext make cmake file zip && \
  git clone https://github.com/neovim/neovim.git &&\
  cd neovim && \
  make CMAKE_BUILD_TYPE=RelWithDebInfo && \
  cd build && \
  cpack -G DEB && \
  dpkg -i nvim-linux64.deb

RUN \
  addgroup ubuntu && \
  useradd  -s /bin/bash -u 1000 -m -g ubuntu ubuntu

USER ubuntu

RUN \
  git clone --depth 1 https://github.com/ostavnaas/dotfiles /home/ubuntu/dotfiles && \
  mkdir /home/ubuntu/.config && \
  ln -s /home/ubuntu/dotfiles/nvim /home/ubuntu/.config/  && \
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
