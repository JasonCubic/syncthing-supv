# Introduction

Syncthing with supervisor Dockerfile

You will notice that when Syncthing is shutdown in the web gui that it will start back up.  This behavior is intentional in this supervisor implementation of Syncthing.  The supervisor is bundled in the container with syncthing.

# Prerequisites

You first need to create the directories that Syncthing will use to store its configuration and sync data.  Or else the config and sync data will be lost everytime the container is stopped.

```bash
sudo mkdir -p /srv/docker/volumes/syncthing/{config,sync}
```

# An example run command

```bash
docker run -d --name='syncthing' \
-p 8080:8080 -p 22000:22000 -p 21025:21025/udp \
-v /srv/docker/volumes/syncthing/config:/home/syncthing/.config/syncthing \
-v /srv/docker/volumes/syncthing/sync:/home/syncthing/Sync \
-e 'STGUIADDRESS=https://0.0.0.0:8080' \
jasoncubic/syncthing-supv
```