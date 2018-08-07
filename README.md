# Supercharged Machine Learning ToolBox

A [Docker](http://docker.com) image for AMD & ARM devices with [Tensorflow 1.9.0rc0](https://www.tensorflow.org/) an open source software library for numerical computation using data flow graphs that will let you play and learn distinct Machine Learning techniques over [JupyterLab](https://github.com/jupyterlab/jupyterlab) an open-source web application that allows you to create and share documents that contain live code, equations, visualizations and explanatory text. Computational Narratives as the Engine of Collaborative Data Science. All this under Python 2.7 language.
There is very similar image based on Python 3.4 instead of 2.7 [elswork/tensorflow-py3](https://hub.docker.com/r/elswork/tensorflow-py3/).

> Be aware! You should read carefully the usage documentation of every tool!

## Details

- [GitHub](https://github.com/DeftWork/tensorflow)
- [Docker Hub](https://hub.docker.com/r/elswork/tensorflow/)
- [Deft.Work my personal blog](http://deft.work/tensorflow_for_raspberry)

## Thanks to

- [Romilly Cocking for the idea](https://github.com/romilly/rpi-docker-tensorflow)
- Pi tensorflow whl file that i builded thanks to [Sam Abrahm's Step-By-Step Guide for build Tensorflow for Raspberry Pi](https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md)

## Build Instructions

Build for amd64 architecture

```sh
docker build -t elswork/tensorflow:latest .
```

Build for arm32v7 architecture

```sh
docker build -t elswork/tensorflow:latest \
 --build-arg WHL_URL=http://ci.tensorflow.org/view/Nightly/job/nightly-pi/lastSuccessfulBuild/artifact/output-artifacts/ \
 --build-arg WHL_FILE=tensorflow-1.9.0rc0-cp27-none-linux_armv7l.whl .
```

## My Real Usage Example

In order everyone could take full advantages of the usage of this docker container, I'll describe my own real usage setup.
For arm32v7 architecture replace latest by arm32v7 tag.

```sh
docker run -d -p 8888:8888 elswork/tensorflow:latest
```

A more complex sample:

```sh
docker run -d -p 8888:8888 -p 0.0.0.0:6006:6006 \
 --restart=unless-stopped elswork/tensorflow:latest
```

Point your browser to `http://localhost:8888`

First time you open it, you should provide a Token to log on you cand find it with this command:

```sh
docker logs container_name
```

With the second example you can run TensorBoard executing this command in the container:

```sh
tensorboard --logdir=path/to/log-directory --host=0.0.0.0
```

And pointing your browser to `http://localhost:6006`

## Latest Changes

### 1.9.0rc0

- Starting from Tensorflow 1.9.0rc0