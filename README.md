# Docker image for kotlin-cross compilation

This docker images allows you to cross-compile Kotlin/Native apps for a Raspberry Pi on a macOS, Linux or Windows system.

The final image is based on the [gradle image](https://hub.docker.com/_/gradle/) and will contain a jdk as well as gradle to build your projects.

## Build the image

Build the image by using the provided `build.sh` script.

## Run the container

If you want to reuse a container you can set it up with the following command.

```
docker run --rm -it -v $(pwd):/home/gradle -w /home/gradle --name kotlinc roamingthings/kotlin-native /bin/bash
```

This will map the current directory (your project folder) to the build-directory of the container.

If you're using gradle you may not want the plugins, its dependencies and the Kotlin/Native compiler to be downloaded each time.
For this reason you can map the caching-folders to a folder of your host machine by adding `-v $HOME/.konan:/home/gradle/.konan -v $HOME/.gradle:/home/gradle/.gradle`

If you map your `.ssh` folder by adding `-v $HOME:/home/gradle/.ssh` you can also use your ssh-keys inside the container.

The command combining all the above options is:
```
docker run --rm -it -v $(pwd):/home/gradle -v $HOME/.konan:/home/gradle/.konan -v $HOME/.gradle:/home/gradle/.gradle -v $HOME:/home/gradle/.ssh -w /home/gradle --name kotlinc roamingthings/kotlin-native /bin/bash
```

If you want to use the container for automatic building of your project exchange `/bin/bash' with your build command.

For example the following command will execute a local build script that's part of your project

```
docker run --rm -it -v $(pwd):/home/gradle -v $HOME/.konan:/home/gradle/.konan -v $HOME/.gradle:/home/gradle/.gradle -v $HOME:/home/gradle/.ssh -w /home/gradle --name kotlinc roamingthings/kotlin-native ./build.sh
```

## Notes about image size

When the image is build the Kotlin/Native tools will be build from source in an intermediate image. This image will become quite big (several gigs) and you may get a _no space left on device_ error
if your images already need a lot of space. It's save to delete the unnamed image after the final image has been build.
