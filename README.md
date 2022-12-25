# spx-v1.1.2-docker

## Building the container
* This can be used to containerize a development branch, but it is recommended to use tagged releases only, the latest being v1.1.2.
* Download the sources from GitHub and extract:

```sh
curl -sL https://github.com/TuomoKu/SPX-GC/archive/refs/tags/v.1.1.2.tar.gz | tar -xz
```

* Build the container:

```sh
docker build -t spx-v1.1.2 .
```

## Running the container
* If no configuration file is passed to the container, a new ephemeral one is created to `/usr/src/app/config.json`.
* Default port for the web gui in plain http is `5656`.

```sh
docker run -p 5656:5656 -v /home/ubuntu/projektit/SPX-GC-v.1.1.2/config.json:/usr/src/app/config.json spx-v1.1.2
```