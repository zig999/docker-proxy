# Base Image
FROM ubuntu:18.04

ARG user
ARG pass

USER root

# -z the length of STRING is zero
# [] are an alias for test command
# if $user is not empty, write credentials file
RUN if [ ! -z "$user" ]; then echo "${user} ${pass}">/root/proxy_credentials ; fi

#copy bash scripts
COPY configproxy.sh /root
COPY startup.sh .

RUN ["/bin/bash", "-c", ". /root/configproxy.sh"]

# Install dependencies and tool
# Modify as needed
RUN apt-get update -y && \
    apt-get install -yqq --no-install-recommends \
    vim iputils-ping

ENTRYPOINT ["./startup.sh"]
CMD ["sh", "-c", "bash"]