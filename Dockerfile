FROM bz/test-gym-container:0.0.3

RUN apt-get update && \
    apt-get install -y \
        cmake \
        git \
        golang \
        htop \
        libjpeg-dev \
        libsm6 \
        libxrender1 \
        zlib1g-dev

RUN pip install --upgrade pip && \
    pip install \
        "gym[atari]" \
        numpy \
        opencv-python \
        scipy \
        six \
        tensorflow && \
    pip install \
        universe

#WORKDIR /src

#RUN git clone https://github.com/openai/universe-starter-agent

WORKDIR /src/universe-starter-agent
COPY . .

#RUN sed -i -- 's/import gym/import gym, gym_mupen64plus/g' ./envs.py

#COPY entrypoint.sh .
#ENTRYPOINT [ "/bin/bash", "entrypoint.sh" ]
#ENTRYPOINT ["python3", "train.py", \
#            "--num-workers", "2", \
#            "--env-id", "PongDeterministic-v3", \
#            "--log-dir", "/tmp/pong", \
#            "--mode", "child"]



#CUDA_VISIBLE_DEVICES= python worker.py --log-dir /tmp/marioKartLogs --env-id Mario-Kart-Discrete-Luigi-Raceway-v0 --num-workers 2 --job-name ps >/tmp/marioKartLogs/a3c.ps.out 2>&1 &
#CUDA_VISIBLE_DEVICES= python worker.py --log-dir /tmp/marioKartLogs --env-id Mario-Kart-Discrete-Luigi-Raceway-v0 --num-workers 2 --job-name worker --task 0 --remotes 1 >/tmp/marioKartLogs/a3c.w-0.out 2>&1 &

#CUDA_VISIBLE_DEVICES= python worker.py --log-dir /tmp/marioKartLogs --env-id Mario-Kart-Discrete-Luigi-Raceway-v0 --num-workers 2 --job-name worker --task 1 --remotes 1 >/tmp/marioKartLogs/a3c.w-1.out 2>&1 &
#tensorboard --logdir /tmp/marioKartLogs --port 12345 >/tmp/marioKartLogs/a3c.tb.out 2>&1 &

#x11vnc -display :0 -forever -viewonly -rfbport 5900 -shared &