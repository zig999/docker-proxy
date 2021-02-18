# Conditional Proxy Settings for Docker

## State of the problem

I started this project for learning purposes.
The company I work for uses a proxy as a security layer, so internet access must be authenticated. Some devolepers complains about proxy settings dificulties on linux images. Another problem is that we wanted to use same configurations to generate images at company network, but also at home (for testing) where usually don't need any proxy settings. And for last, I would like to avoid user and password settings in configuration files, because sometimes, developers commit it by mistake. So, the requisites are:

- Possibility to turn on and off (conditional) proxy settings when building the image;
- Use CLI arguments for user and password.

The solution I came is based on some tutorials and posts on Stackoverflow.

# Build command

The proxy configuration is enabled by adding the **--build-arg user=<>** to the build command.

## Build without proxy settings

    docker build -t img01 -f Dockerfile . 

## Build with proxy settings

    docker build -t img01 --build-arg user=<USER> --build-arg pass=<PASS> -f Dockerfile . 
