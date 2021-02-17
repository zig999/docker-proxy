# Base Image
FROM ubuntu:18.04

ARG user
ARG pass

USER root

COPY configproxy.sh /root

#RUN ["chmod", "+x", "/root/configproxy.sh"]
RUN if [ ! -z "$user" ]; then echo "${user} ${pass}">/root/proxy_credentials ; fi
RUN ["/bin/bash", "-c", ". /root/configproxy.sh"]

# Install dependencies and tools
#RUN apt-get update -y && \
#    apt-get install -yqq --no-install-recommends \
#    vim iputils-ping

COPY startup.sh .
ENTRYPOINT ["./startup.sh"]
CMD ["sh", "-c", "bash"]