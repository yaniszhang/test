# https://github.com/CreditTone/FuckingWallOfChina
if [ $# -eq 0 ]; then
  echo "没有传递端口号"
  exit 1
fi

cd ~
apt update
apt install curl vim git
wget -nc -O go1.17.7.linux-amd64.tar.gz https://dl.google.com/go/go1.17.7.linux-amd64.tar.gz
tar -xf go1.17.7.linux-amd64.tar.gz
rm -r /usr/local/go
mv go /usr/local
cat > .profile << "EOF"
# ~/.profile: executed by Bourne-compatible login shells1.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

tty -s && mesg n || true
EOF
. ~/.profile
go env -w GO111MODULE=off
go get -v github.com/elazarl/goproxy
echo "package main

import (
    "github.com/elazarl/goproxy"
    "log"
    "net/http"
)

func main() {
    proxy := goproxy.NewProxyHttpServer()
    proxy.Verbose = true
    log.Fatal(http.ListenAndServe(\"127.0.0.1:$1\", proxy))
}"> goproxy.go
cat > goproxy.sh << "EOF"
nohup go run /root/goproxy.go &
EOF
wget -nc -O frp_0.42.0_linux_amd64.tar.gz https://github.com/fatedier/frp/releases/download/v0.42.0/frp_0.42.0_linux_amd64.tar.gz
tar -zxf frp_0.42.0_linux_amd64.tar.gz
rm -r frp
mv frp_0.42.0_linux_amd64 frp
echo "[common]
server_addr = 81.68.217.182
server_port = 7000

[$1]
type = tcp
local_ip = 127.0.0.1
local_port = $1
remote_port = $1
"> frp/frpc.ini
cat > frp/frpc.sh << "EOF"
nohup ./frpc -c ./frpc.ini&
EOF

