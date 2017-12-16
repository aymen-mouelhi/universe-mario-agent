FROM bz/test-gym-container:0.0.4

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
    # Don't know why, but this one wanted to be installed separately
    pip install \ 
        universe

# Copy the current directory to the container working dir
WORKDIR /src/universe-starter-agent
COPY . .

# Expose the port for Tensorboard
EXPOSE 12345
