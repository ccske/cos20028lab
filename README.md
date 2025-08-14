# COS20028 Lab
Building lab environment on Docker for COS20028.

## Build Hadoop Docker image
$ docker build -t cos20028lab/hadoop:3.4.0-ubuntu24-jdk11 ./hadoop

## Start up a 4-node Hadoop cluster via Docker Compose
$ docker compose up --build -d

## Shut down the 4-node Hadoop cluster via Docker Compose
$ docker compose down
