FROM openjdk:8-jdk as builder
MAINTAINER Alexander Sparkowsky <info@roamingthings.de>

USER root

ARG KOTLIN_NATIVE_VERSION=v0.5

RUN apt-get update && apt-get install -yq \
        libncurses-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd / && \
    git clone -b ${KOTLIN_NATIVE_VERSION} --single-branch --depth 1 https://github.com/JetBrains/kotlin-native.git && \
    cd /kotlin-native && ./gradlew wrapper && \
    cd /kotlin-native && ./gradlew dependencies:update && \
    cd /kotlin-native && ./gradlew bundle --info --stacktrace

FROM gradle:latest

USER root

RUN apt-get update && apt-get install -yq \
        libncurses-dev less sudo nano cmake openjfx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN usermod -aG sudo gradle && \
    echo "gradle\tALL=NOPASSWD: ALL\n" >> /etc/sudoers

COPY --from=builder /kotlin-native/dist /opt/kotlin-native/

RUN chmod 755 ${pkgdir}/opt/kotlin-native && \
    ln -s /opt/kotlin-native/bin/cinterop /usr/bin/cinterop && \
    ln -s /opt/kotlin-native/bin/klib /usr/bin/klib && \
    ln -s /opt/kotlin-native/bin/konanc /usr/bin/konanc && \
    ln -s /opt/kotlin-native/bin/kotlinc /usr/bin/kotlinc && \
    ln -s /opt/kotlin-native/bin/kotlinc-native /usr/bin/kotlinc-native && \
    ln -s /opt/kotlin-native/bin/run_konan /usr/bin/run_konan

USER gradle

VOLUME "/home/gradle/.konan"
WORKDIR /home/gradle
