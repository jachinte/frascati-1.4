# jachinte/frascati-1.4

![Docker](http://s32.postimg.org/cs6e5svtd/docker.png)&nbsp;&nbsp;&nbsp;&nbsp;![FraSCAti](http://s32.postimg.org/dz1yf1sep/frascati.jpg)

This docker container installs FraSCAti 1.4, with the following features:

- Ubuntu 16.04 base image
- openssh-server (latest)
- vsftpd (latest)
- Oracle Java 1.6.0_23
- [FraSCAti 1.4](http://forge.ow2.org/project/showfiles.php?group_id=329) with [enhanced binaries](https://github.com/jachinte/frascati-binaries)

## Installation from [Docker registry hub](https://hub.docker.com/r/jachinte/frascati-1.4/).

```
docker pull jachinte/frascati-1.4
```

## Exposed ports

This container exports ports `21` and `22`.

## Usage

`docker run -d -p [HOST PORT NUMBER]:21 -p [HOST PORT NUMBER]:22 --name <name> jachinte/frascati-1.4`
