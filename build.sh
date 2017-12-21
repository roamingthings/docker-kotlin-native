#!/bin/sh
docker build -t roamingthings/kotlin-native:latest . && \
docker image tag roamingthings/kotlin-native:latest roamingthings/kotlin-native:0.5 && \
docker image tag roamingthings/kotlin-native:latest roamingthings/kotlin-native:v0.5
