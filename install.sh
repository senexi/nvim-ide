#!/bin/bash

# determin architecture x86_64 or arm64
ARC=$(arch) 
echo "Architectur is $ARC"
if [ "$ARC" = "x86_64" ]; then
    echo "USING x86_64 arcitecture"
    ARCH="amd64"
    ARCH2=$ARC 
fi
if [ "ARC" = "arm64" ]; then
   ARCH="arm64v8"
   ARCH2="aarch64" 
   ARCH=$ARC
fi


export GOROOT=/usr/local/go
export GOPATH=/go
export GOBIN=/go/bin
export PATH=$GOBIN:$PATH
export PATH=$GOROOT/bin:$PATH
export HOME=/home/dev

echo "install node"
curl -fsSL https://deb.nodesource.com/setup_current.x | bash - 
apt-get install -q --no-install-recommends -y nodejs 
npm install --global yarn
npm install -g neovim

echo "install protobuf compiler"
PB_REL=https://github.com/protocolbuffers/protobuf/releases
PB_VER=3.17.3
PB_FILE=protoc-${PB_VER}-linux-x86_64.zip
PB_URL=${PB_REL}/download/v${PB_VER}/${PB_FILE}

PB_DEST=/tmp/protoc
echo ${PB_URL} 
wget -q ${PB_URL} -P ${PB_DEST}
unzip -qq ${PB_DEST}/${PB_FILE} -d ${PB_DEST}
chmod +x ${PB_DEST}/bin/protoc
mv ${PB_DEST}/bin/protoc /usr/local/bin
mv ${PB_DEST}/include /usr/local/bin
chmod -R 755 /usr/local/bin/include


echo "install go"
GO_VER=1.17
GO_URL=https://golang.org/dl/go${GO_VER}.linux-${ARCH}.tar.gz
wget -q -c ${GO_URL} -O - | tar -xz -C /usr/local
mkdir -p /go/src /go/bin /go/pkg

#echo "install go protobuf support" 
#go get -u google.golang.org/protobuf/cmd/protoc-gen-go
#go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc
#go get -u github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc
#go get -u github.com/cweill/gotests/...


echo "install terraform"
TERRAFORM_VERSION=1.0.5
wget -q --progress=dot:mega https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip
unzip -qq terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip 
mv terraform /usr/local/bin/
chmod +x /usr/local/bin/terraform 
terraform --version


echo "install aws cli"
#curl "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH2}.zip" -o "awscliv2.zip"
#unzip -qq awscliv2.zip
#./aws/install
pip3 --no-cache-dir install --upgrade awscli


echo "install kubectl"
curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "install helm"
curl -s https://baltocdn.com/helm/signing.asc | apt-key add - 
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get -q update
apt-get install --no-install-recommends -q helm

echo "install istioctl"
curl -sL https://istio.io/downloadIstioctl | TARGET_ARCH=${ARCH2} sh -
mv $HOME/.istioctl/bin/istioctl /usr/bin/istioctl

echo "install kubeseal"
if [ "$ARCH" = "amd64" ]  
then 
    wget -q https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.16.0/kubeseal-linux-${ARCH} -O kubeseal
    install -m 755 kubeseal /usr/local/bin/kubeseal
fi


echo "install argo"
curl -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.1.8/argo-linux-${ARCH}.gz
gunzip argo-linux-${ARCH}.gz
chmod +x argo-linux-${ARCH}
mv ./argo-linux-${ARCH} /usr/bin/argo
# mkdir -p $HOME/.oh-my-zsh/custom/plugins/argo
# argo completion zsh > $HOME/.oh-my-zsh/custom/plugins/argo/argo.plugin.zsh

echo "install argocd"
ARGOCD_VERSION=v2.1.0
if [ "$ARCH" = "amd64" ]  
then 
    curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-${ARCH}
    chmod +x /usr/local/bin/argocd 
#    mkdir -p $HOME/.oh-my-zsh/custom/plugins/argocd
#    argocd completion zsh > $HOME/.oh-my-zsh/custom/plugins/argocd/argocd.plugin.zsh
fi


echo "install pip packages"
pip3 install pylint

echo "set ownership for home/dev to user dev"
chown -R dev:0 /home/dev 
chown -cR dev:0 /go && chmod -R g+rwX /go
