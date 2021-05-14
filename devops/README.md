# devops environment

```

#run with
podman run -it -w /data -v $(pwd):/data --userns=keep-id --rm --net=host senexi/devops-ide:amd64-latest /bin/zsh

#set alias
alias devopside='podman run -it -w /data -v $(pwd):/data --userns=keep-id --rm --net=host senexi/devops-ide:amd64-latest /bin/zsh'
```
