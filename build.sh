#!/bin/sh
docker build -t roamingthings/kotlin-native:latest . && \
docker image tag roamingthings/kotlin-native:latest roamingthings/kotlin-native:1.0.3 && \
docker image tag roamingthings/kotlin-native:latest roamingthings/kotlin-native:v1.0.3
