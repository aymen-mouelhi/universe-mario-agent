FROM aymen/gym-docker:latest

RUN apt-get update && \
    apt-get install -y \
        cmake \
        git \
        golang \
        htop \
        libjpeg-dev \
        libsm6 \
        python-opencv \
        libopencv-dev \
        python-numpy \
        python-dev \
        libxrender1 \
        zlib1g-dev

RUN pip install --upgrade pip && \
    pip install \
        "gym[atari]" \
        numpy \
        panda \
        opencv-python \
        scipy \
        six \
        tensorflow && \
    # Don't know why, but this one wanted to be installed separately
    pip install \
        universe

# Copy the current directory to the container working dir
WORKDIR /src/universe-starter-agent
COPY . .

# Expose the port for Tensorboard
EXPOSE 12345
