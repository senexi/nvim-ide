#!/bin/bash
export GOROOT=/usr/local/go
export GOPATH=/go
export GOBIN=/go/bin
export PATH=$GOBIN:$PATH
export PATH=$GOROOT/bin:$PATH

nvim --headless +PlugInstall  +qall && timeout 20 nvim --headless +"CocInstall coc-go coc-json coc-jedi" test.py || : && echo "huhu"

pip3 install --user --upgrade neovim

JAVA_VERSION="11.0.11-zulu"
KOTLIN_VERSION="1.4.31"
MAVEN_VERSION="3.6.3"
GRADLE_VERSION="6.8.3"
curl -s "https://get.sdkman.io" | zsh 
zsh -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    yes | sdk install java $JAVA_VERSION && \
    yes | sdk install kotlin $KOTLIN_VERSION && \
    yes | sdk install maven $MAVEN_VERSION && \
    yes | sdk install gradle $GRADLE_VERSION" 
JAVA_HOME="$HOME/.sdkman/candidates/java/current"

#configure git to use ssh instead of https
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k 
git config --global user.email "dev@go.com"
git config --global user.name "dev"
git config --global url."git@github.com:".insteadOf "https://github.com/"
