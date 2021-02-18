# Conditional Proxy Settings for Docker

## State of the problem

I started this project for learning purposes.
The company I work for uses a proxy as a security layer, so internet access must be authenticated. Some devolepers complains about proxy settings dificulties on linux images. Another problem is that we wanted to use same configurations to generate images at company network, but also at home (for testing) where usually don't need any proxy settings. And for last, I would like to avoid user and password settings in configuration files, because sometimes, developers commit it by mistake. So, the requisites are:

- Possibility to turn on and off (conditional) proxy settings when building the image;
- Use CLI arguments for user and password.
- Add apt.conf with proxy credential
- Add proxy environment variables

The solution I came is based on some tutorials and posts on Stackoverflow.

# Build command

The proxy configuration is enabled by adding the **--build-arg user=<>** to the build command.

## Build without proxy settings

    docker build -t img01 -f Dockerfile . 

## Build with proxy settings

    docker build -t img01 --build-arg user=<USER> --build-arg pass=<PASS> -f Dockerfile . 

# The solution

I used some shell scripts to make it possible conditional configurations. Because environment variables are not persisted after the build proccess, the script should run every time a container is started to.

## Entrypoint script

As pointed on the [docs](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#entrypoint):

>The ENTRYPOINT instruction can also be used in combination with a helper script...

The structure of the script is as follow:

    #!/bin/bash
    
    # Run any other commands needed 
    
    # Run the main container command
    exec "$@"

From [unix.stackexchange](https://unix.stackexchange.com/questions/466999/what-does-exec-do):

>The "\$@" bit will expand to the list of positional parameters (usually the command line arguments), individually quoted to avoid word splitting and filename generation ("globbing").\
The exec will replace the current process with the process resulting from executing its argument.\
>In short, exec "\$@" will run the command given by the command line parameters in such a way that the current process is replaced by it (if the exec is able to execute the command at all).

So, in the Dockerfile:

    ENTRYPOINT ["./startup.sh"]
    CMD ["sh", "-c", "bash"]

This configure startup.sh as an entrypoint for every startup. The CMD carries the command, "bash" in this case to the script, which will be executed "exec \$@".

# Proxy configurations

## Apt.conf 

To configure proxy for apt command, you can add proxy credential to /etc/app/apt.conf file. The sintax is:

    Acquire::http::proxy "http://<user>:<password>@<proxy_url>:8080";
    Acquire::https::proxy "https://<user>:<password>@<proxy_url>:8080";

For shell internet access, two environment variables are needed:

- http_proxy
- https_proxy

To set the proxy server to these variables, the export command is used.
