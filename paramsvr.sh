#!/bin/bash
pip install mss # TODO: Remove this line once this dependency is moved into the env docker image
CUDA_VISIBLE_DEVICES= python worker.py --log-dir /tmp/marioKartLogs --env-id Mario-Kart-Discrete-Luigi-Raceway-v0 --job-name ps >/tmp/marioKartLogs/a3c.ps.out 2>&1
tensorboard --logdir /tmp/marioKartLogs --port 12345 >/tmp/marioKartLogs/a3c.tb.out 2>&1 &
tail -f /tmp/marioKartLogs/a3c.ps.out
