# COS20028 Lab
Building lab environment on Docker for COS20028.


## (Optional) Prepare environment for Ubuntu virtual machine
Theoretically, the instructions listed in this article can work on any systems where Docker and Docker Compose are ready.
If you don't have a proper operating environment, or you would just like a test drive, you can create an Ubuntu (> 24.04) virtual machine and run the script to set up the prerequisite environment.
```shell
$ cd /path/to/cos20028lab
$ ./ubuntu-vm-prep.sh
```


## Build Hadoop Docker image
This is optional and perhaps only for debugging purpose, as the `docker compose` will build the image before making use of it to launch containers.
```shell
$ cd /path/to/cos20028lab
$ docker build -t cos20028lab/hadoop:3.4.0-ubuntu24-jdk11 ./hadoop
```


## Start up a 4-node Hadoop cluster via Docker Compose
The instructions below will build the Hadoop Docker image if missing and then start up a 4-node Hadoop cluster.
```shell
$ cd /path/to/cos20028lab
$ docker compose up --build -d
```
After all Docker containers are up and running, you should be able to browse the Hadoop web UI:
* HDFS NameNode UI: `http://{DOCKER_HOST}:9870`
* YARN ResourceManager UI: `http://{DOCKER_HOST}:8088`

where the `{DOCKER_HOST}` is the hostname of the machine where Docker containers are running, or `localhost` if the browser is running on the same machine.


## Shut down the 4-node Hadoop cluster via Docker Compose
The instructions below will shut down the Hadoop cluster and remove all containers, but the data and logs are stored in the persistent Docker volumes; once another Hadoop cluster is launched, it will reuse the Docker volumes.
```shell
$ cd /path/to/cos20028lab
$ docker compose down
```
