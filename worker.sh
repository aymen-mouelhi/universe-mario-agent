#!/bin/bash
pip install mss # TODO: Remove this line once this dependency is moved into the env docker image
cp /src/gym-mupen64plus/gym_mupen64plus/marioKart.n64 /src/gym-mupen64plus/gym_mupen64plus/ROMs/
CUDA_VISIBLE_DEVICES= python worker.py --log-dir /tmp/marioKartLogs --env-id Mario-Kart-Discrete-Luigi-Raceway-v0 --job-name worker --remotes 1 >/tmp/marioKartLogs/a3c.w-`hostname`.out 2>&1
x11vnc -display :0 -forever -viewonly -rfbport 5900 -shared &
tail -f /tmp/marioKartLogs/a3c.w-`hostname`.out
