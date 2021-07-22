# ARCH=arm64v8 or amd64
ARG ARCH

FROM ${ARCH}/ubuntu:groovy
ARG ARCH
ARG ARCH2=x86_64
ARG ARCH3
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && apt-get -qq install vim \
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
    apt-transport-https \
    jsonnet \
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


COPY --chown=dev:0 rootfs /
ARG TERRAFORM_VERSION=0.15.5

#install terraform
RUN wget --progress=dot:mega https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH3}.zip

RUN \
	# Unzip
	unzip terraform_${TERRAFORM_VERSION}_linux_${ARCH3}.zip && \
	# Move to local bin
	mv terraform /usr/local/bin/ && \
	# Make it executable
	chmod +x /usr/local/bin/terraform && \
	# Check that it's installed
	terraform --version

#install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH2}.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

#install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && apt-get install -y kubectl

#install helm
RUN curl https://baltocdn.com/helm/signing.asc | apt-key add - && \
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && apt-get install helm

#install istioctl
RUN curl -sL https://istio.io/downloadIstioctl | TARGET_ARCH=${ARCH2} sh - && \
    mv $HOME/.istioctl/bin/istioctl /usr/bin/istioctl

#install kubeseal
RUN if [ "$ARCH" = "amd64" ] ; then wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.16.0/kubeseal-linux-${ARCH3} -O kubeseal && \
    install -m 755 kubeseal /usr/local/bin/kubeseal; fi

USER dev
ENV HOME /home/dev
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV GOBIN /go/bin
ENV PATH $GOBIN:$PATH
ENV PATH $GOROOT/bin:$PATH
WORKDIR ${HOME} 

RUN pip3 install pylint

RUN nvim --headless +PlugInstall  +qall && timeout 20 nvim --headless +"CocInstall coc-go coc-json coc-jedi" test.py || : && echo "huhu"

# install protobuf support 
RUN go get -u google.golang.org/protobuf/cmd/protoc-gen-go && \
    go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc && \
    go get -u -v github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc && \
    go get -u github.com/cweill/gotests/...

ARG JAVA_VERSION="11.0.11-zulu"
ARG KOTLIN_VERSION="1.4.31"
ARG MAVEN_VERSION="3.6.3"
ARG GRADLE_VERSION="6.8.3"
RUN curl -s "https://get.sdkman.io" | zsh && \
    zsh -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
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

USER root

#install argo
RUN curl -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.1.1/argo-linux-${ARCH3}.gz && \
    gunzip argo-linux-${ARCH3}.gz && \
    chmod +x argo-linux-${ARCH3} && \
    mv ./argo-linux-${ARCH3} /usr/bin/argo && \
    mkdir $HOME/.oh-my-zsh/custom/plugins/argo && \
    argo completion zsh > $HOME/.oh-my-zsh/custom/plugins/argo/argo.plugin.zsh

#install argocd
ARG ARGOCD_VERSION=v2.0.1
RUN if [ "$ARCH" = "amd64" ] ; then curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-${ARCH3} && \
    chmod +x /usr/local/bin/argocd && \
    mkdir $HOME/.oh-my-zsh/custom/plugins/argocd && \
    argocd completion zsh > $HOME/.oh-my-zsh/custom/plugins/argocd/argocd.plugin.zsh ; fi

USER dev

COPY --chown=dev:0 rootfs/home/dev/.p10k.zsh rootfs/home/dev/.zshrc ${HOME}

CMD "exec zsh"

