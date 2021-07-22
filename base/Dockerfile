# ARCH=arm64v8 or amd64
ARG ARCH

FROM ${ARCH}/ubuntu:groovy

# add dev user
RUN adduser dev --disabled-password --gecos ""                          && \
    echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers   
#    chsh -s /usr/bin/zsh dev \
COPY install_base.sh /tmp
RUN /tmp/install_base.sh

COPY --chown=dev:0 rootfs /

COPY install.sh /tmp
RUN /tmp/install.sh

USER dev
ENV HOME /home/dev
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV GOBIN /go/bin
ENV PATH $GOBIN:$PATH
ENV PATH $GOROOT/bin:$PATH
WORKDIR ${HOME} 

COPY install_user.sh /tmp
RUN /tmp/install_user.sh
COPY --chown=dev:0 rootfs/home/dev/.p10k.zsh rootfs/home/dev/.zshrc ${HOME}

CMD "exec zsh"

