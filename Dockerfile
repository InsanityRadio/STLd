FROM ubuntu:focal

RUN apt-get update && apt-get install alsa gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-tools gstreamer1.0-alsa curl -y --no-install-recommends 

WORKDIR /opt
COPY ./stld /opt/stld
RUN chmod +x /opt/stld

ENTRYPOINT /opt/stld
