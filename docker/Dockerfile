# ==============================================================================
FROM ubuntu:18.04 as builder

# Development Tools
RUN apt update && apt install -y curl wget tree less git vim tmux htop parallel unzip

# Compilers
RUN apt update && apt install -y clang-10 lld-10 && \
  ln -s /usr/bin/clang-10 /usr/bin/clang && \
  ln -s /usr/bin/clang++-10 /usr/bin/clang++ 

# Installs required libraries for cross-compilation
#  gcc-4.7-arm-linux-gnueabihf
#  gcc-4.7-multilib-arm-linux-gnueabihf
#  binutils-arm-linux-gnueabihf
#  libgcc1-armhf-cross
#  libsfgcc1-armhf-cross
#  libstdc++6-armhf-cross
#  libstdc++6-4.7-dev-armhf-cross 
RUN apt update && apt install -y crossbuild-essential-armhf libz-dev
RUN apt update && apt install -y crossbuild-essential-arm64
RUN apt update && apt install -y qemu-user

# Tensorflow latest-devel image comes with clang-format pre-installed 
# RUN apt install clang-format-10 && \
#     ln -s /usr/bin/clang-format-10 /usr/bin/clang-format

WORKDIR /tmp
RUN wget https://github.com/Kitware/CMake/releases/download/v3.18.2/cmake-3.18.2-Linux-x86_64.sh && \
    chmod +x cmake-3.18.2-Linux-x86_64.sh && \
    ./cmake-3.18.2-Linux-x86_64.sh --skip-license --prefix=/usr/local

RUN wget https://github.com/ninja-build/ninja/releases/download/v1.10.1/ninja-linux.zip && \
    unzip ninja-linux.zip && \
    mv ninja /usr/local/bin/ninja && \
    ln -s /usr/local/bin/ninja /usr/sbin/ninja

# Requirements for VSCODE plugins
WORKDIR /usr/local/bin
RUN wget -q https://github.com/bazelbuild/buildtools/releases/download/3.2.1/buildifier -O buildifier

# Setup some convenient tools/functionalities
WORKDIR /root
RUN git clone https://github.com/agostini01/dotfiles.git && \
    \
    ln -sf dotfiles/.gitignore_global .gitignore_global && \
    \
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    \
    ln -sf dotfiles/.vimrc            .vimrc && \
    ln -sf dotfiles/.ctags            .ctags && \
    ln -sf dotfiles/.inputrc          .inputrc && \
    \
    git clone https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm && \
    ln -sf dotfiles/.tmux.conf        .tmux.conf

RUN echo "PS1='\[\033[01;31m\][\[\033[01;30m\]\u@\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '" >> .bashrc

RUN echo "export CXX=/usr/bin/clang++" >> ~/.bashrc && \
    echo "export CC=/usr/bin/clang" >> ~/.bashrc
ENV CXX=/usr/bin/clang++ 
ENV CC=/usr/bin/clang 

# ============================================================================
FROM builder AS dev-user
# Add dev user with matching UID of the user who build the image
ARG USER_ID
ARG GROUP_ID
RUN useradd -m --uid $USER_ID developer && \
    echo "developer:devpasswd" | chpasswd && \
    usermod -aG dialout developer && \
    usermod -aG sudo developer

USER developer
WORKDIR /home/developer
RUN git clone https://github.com/agostini01/dotfiles.git && \
    \
    ln -sf dotfiles/.gitignore_global .gitignore_global && \
    \
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    \
    ln -sf dotfiles/.vimrc            .vimrc && \
    ln -sf dotfiles/.ctags            .ctags && \
    ln -sf dotfiles/.inputrc          .inputrc && \
    \
    git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm && \
    ln -sf dotfiles/.tmux.conf        .tmux.conf

RUN echo "PS1='\[\033[01;31m\][\[\033[01;30m\]\u@\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '" >> .bashrc

# Select clang compiler
RUN echo "export CXX=/usr/bin/clang++-10" >> ~/.bashrc && \
    echo "export CC=/usr/bin/clang-10" >> ~/.bashrc

# Print welcome message
WORKDIR /home/developer
RUN echo "echo 'Welcome to the AXI4MLIR tools container'" >> ~/.bashrc && \
    echo "echo ' '" >> ~/.bashrc && \
    echo "echo 'NOTE:'" >> ~/.bashrc && \
    echo "echo '    /working_dir folder was volume mounted'" >> ~/.bashrc && \
    echo "echo ' '" >> ~/.bashrc 
