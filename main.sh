#!/bin/bash
unset DISPLA

echo "set -g mouse on" > ~/.tmux.conf

tmux kill-session -t server
tmux kill-session -t placeholder

cd /root/TelixMC/bungee
tmux new -d -s server "java -Djava.awt.headless=true -jar bungee.jar; tmux kill-session -t server"
cd ../server
if [ ! -f "server.jar" ] && [ -d "../cuberite" ]; then
  cd ../cuberite
  tmux splitw -t server -v "BIND_ADDR=127.0.0.1 LD_PRELOAD=../bindmod.so ./Cuberite; tmux kill-session -t server"
else
  tmux splitw -t server -v "java -Djline.terminal=jline.UnsupportedTerminal -Xmx512M -jar server.jar nogui; tmux kill-session -t server"
fi
cd ..
while tmux has-session -t server
do
  tmux a -t server
done
