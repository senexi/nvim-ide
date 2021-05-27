# ARCH=arm64v8 or amd64
ARG ARCH

FROM ${ARCH}/ubuntu:groovy
ARG ARCH
ARG ARCH3
RUN apt-get update -y && apt-get -y install vim \
	nodejs \
	silversearcher-ag \
	protobuf-compiler \
	postgresql-client \
	less \
    mpv \
	zsh \
    git \
    gnupg \
    make \
    wget \
    gcc \
    exuberant-ctags \
    curl \
    neovim \
    zip \
    jq \
    iputils-ping \
    netcat \
    nmap \
    python3-pip \
    python3-venv \
    yarn
RUN wget -c https://dl.google.com/go/go1.16.4.linux-${ARCH3}.tar.gz -O - | tar -xz -C /usr/local && \
    mkdir /go && \
    printf 'export GOPATH=/go \n\
export GOBIN=$GOPATH/bin \n\
export PATH=$PATH:$GOPATH/bin \n\
export GOROOT=/usr/local/go \n\
export PATH=$PATH:$GOROOT/bin' >> /etc/profile

# add dev user
RUN adduser dev --disabled-password --gecos ""                          && \
    echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers     && \
    chown -R dev:dev /home/dev /go && \
    chgrp -R 0 /home/dev /go && \
    chmod -R g+rwX /home/dev /go
#    chsh -s /usr/bin/zsh dev \

USER dev
ENV HOME /home/dev
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV GOBIN /go/bin
ENV PATH $GOBIN:$PATH
ENV PATH $GOROOT/bin:$PATH
WORKDIR ${HOME} 

RUN pip3 install pylint

COPY --chown=dev:0 init.vim ${HOME}/.config/nvim/
RUN nvim --headless +PlugInstall  +qall && timeout 20 nvim --headless +"CocInstall coc-go coc-json coc-jedi" test.py || : && echo "huhu"
COPY --chown=dev:0 coc-settings.json ${HOME}/.config/nvim

# install protobuf support 

RUN go get -u google.golang.org/protobuf/cmd/protoc-gen-go && \
    go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc && \
    go get -u -v github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc && \
    go get -u github.com/cweill/gotests/...


RUN curl -s "https://get.sdkman.io" | zsh
ARG JAVA_VERSION="11.0.11-zulu"
ARG KOTLIN_VERSION="1.4.31"
ARG MAVEN_VERSION="3.6.3"
ARG GRADLE_VERSION="6.8.3"
RUN zsh -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    yes | sdk install java $JAVA_VERSION && \
    yes | sdk install kotlin $KOTLIN_VERSION && \
    yes | sdk install maven $MAVEN_VERSION && \
    yes | sdk install gradle $GRADLE_VERSION" 
ENV JAVA_HOME="$HOME/.sdkman/candidates/java/current"

#configure git to use ssh instead of https
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k && \
    git config --global user.email "dev@go.com" && \
    git config --global user.name "dev" && \
    git config --global url."git@github.com:".insteadOf "https://github.com/"

COPY --chown=dev:0 .p10k.zsh ${HOME}/.p10k.zsh
COPY --chown=dev:0 .zshrc ${HOME}/.zshrc
CMD "exec zsh"

