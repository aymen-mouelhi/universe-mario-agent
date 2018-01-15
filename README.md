# Mario Kart A3C Agent

Forked/branched from the [universe-starter-agent](https://github.com/openai/universe-starter-agent). Several tweaks have been made to allow this agent to work with the [gym-mupen64plus](https://github.com/bzier/gym-mupen64plus) N64 environment (specifically for the MarioKart64 game). This initial set of commits is currently unrefined/hacky/sloppy and needs significant cleanup. However, it is functional at this point.

## Contents:
* [Getting Started](#getting-started)
* [Build](#build)
* [Agent Training](#agent-training)
  * [Start training](#start-training)
  * [Scaling workers](#scaling-workers)
  * [Stop training](#stop-training)
  * [Monitoring training](#monitoring-training)

# Getting Started

This project is dependent upon the gym-mupen64plus project. To build & run this agent, you will need to have that set up first. The easiest, cleanest, most consistent way to get up and running with each of these projects is via Docker. These instructions will focus on that approach. It is possible to run without Docker, but there isn't a compelling reason to and it just introduces a significant amount of setup work and potential complications.

# Build

1. Follow the Docker build instructions for gym-mupen64plus [here]() and remember the image name and tag you use

    > If you've already done this, but don't remember the image and tag, you can find them by listing all of your images with:
    >```sh
    >docker images
    >```

2. Update the first line of the `Dockerfile` in this directory (the one with this README file) with the image name and tag from the previous step
    ```Dockerfile
    # Example:
    FROM bz/gym-mupen64plus:0.0.5
    ```
3. Run the following command to build this agent project

    > You should substitute the placeholders between `< >` with your own values.
    >
    > Note: this is an image name for this agent, ***not*** for the underlying environment image that you created in step 1

    ```sh
    docker build -t <a3c_image_name>:<tag> .
    ```
    ```sh
    # Example:
    docker build -t bz/mario-kart-a3c:0.0.5 .
    ```
4. Create a new file in this directory called `.env` with the following variables defined (no quotes):
    ```sh
    # The values you chose during step 3
    IMAGE_SPEC=<a3c_image_name>:<tag>

    # Some path on your host system to where you store the Mario Kart ROM file
    LOCAL_ROM_PATH=<ROM path>
    ```
# Agent Training

In the following examples, I use `mario-kart-agent` as the name of my project. You can use your own name instead, or you can remove the switch (`-p`) and project name and they will default to using the directory name.

## Start training:
After you've completed the build instructions above, starting training is as simple as:
```sh
docker-compose -p mario-kart-agent up -d
```

## Scaling workers:
If you have sufficient CPU, you can also spin up multiple worker containers that all communicate with the same parameter server container:
```sh
docker-compose -p mario-kart-agent up -d --scale worker=2
```
From the original A3C starter agent `README` page, the following recommendation was made. My CPU isn't good enough to even run more than one at a time, so I can't verify if this holds true for Mario Kart as well or not:
>For best performance, it is recommended for the number of workers to not exceed available number of CPU cores.

## Stop training:
When you are done, you can tear down the containers with:
```sh
docker-compose -p mario-kart-agent down
```

**`Note 1`**: This will destroy all of the containers, but not the underlying images that you previously built. You can just follow the instructions in [this section](#start-training) to start again.

**`Note 2`**: This will ***not*** destroy the `mklogs` volume, which is where all of the log data and model checkpoints are stored. This means that starting the containers again will pick up training essentially where it left off (not mid-episode, but with the parameters of the neural network where they were).

## Monitoring training:
### Tensorboard (i.e. training data)
Tensorboard is started in the parameter server container. This container has the Tensorboard port (`12345`) mapped to the same port on your host. In other words, you can browse to [`http://localhost:12345`](http://localhost:12345) to view the Tensorboard UI.

### VNC (i.e. watch the agent)
VNC is started in each worker container. Because workers can be scaled out, we can't map the container port to the host machine. Otherwise each of the containers would conflict fighting for the same host port. Instead, you can examine each worker container with:
```sh
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}::{{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> localhost::{{(index $conf 0).HostPort}}{{end}}' $INSTANCE_ID
```
*Here `$INSTANCE_ID` is the name or ID of the worker container you're interested in*

This will return something like:
```sh
172.17.0.2::5900/tcp -> localhost::32790
```
Then you can use your favorite VNC client to connect to localhost on the dynamically chosen port and watch the agent in real-time. Note that running the VNC client can cause some performance overhead.
