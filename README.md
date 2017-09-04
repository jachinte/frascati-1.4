# jachinte/frascati-1.4

![Docker](http://s32.postimg.org/cs6e5svtd/docker.png)&nbsp;&nbsp;&nbsp;&nbsp;![FraSCAti](http://s32.postimg.org/dz1yf1sep/frascati.jpg)

This docker container installs [FraSCAti 1.4](http://forge.ow2.org/project/showfiles.php?group_id=329) configured with the [enhanced binaries](https://github.com/jachinte/frascati-binaries) and running with Oracle JDK 1.6.0_23.

## Installation from [Docker registry hub](https://hub.docker.com/r/jachinte/frascati-1.4/).

```
docker pull jachinte/frascati-1.4
```

## Usage

```
docker run --rm -ti jachinte/frascati-1.4 frascati --version
```

# Build the image from source

```bash
git clone https://github.com/jachinte/frascati-1.4 & cd frascati-1.4
docker build -t jachinte/frascati-1.4:tag .
# docker push jachinte/frascati-1.4:tag
```
