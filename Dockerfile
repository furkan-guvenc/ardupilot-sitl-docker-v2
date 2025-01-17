FROM ubuntu:20.04

WORKDIR /ardupilot

RUN useradd -U -d /ardupilot ardupilot && \
    usermod -G users ardupilot

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y \
    lsb-release \
    sudo \
    tzdata

RUN apt-get install -y git 
ENV USER=ardupilot
RUN cd / && git clone --depth 1 https://github.com/ArduPilot/ardupilot.git

RUN echo "ardupilot ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ardupilot
RUN chmod 0440 /etc/sudoers.d/ardupilot

RUN chown -R ardupilot:ardupilot /ardupilot

USER ardupilot
RUN /ardupilot/Tools/environment_install/install-prereqs-ubuntu.sh -y
RUN sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /ardupilot

RUN ./waf distclean && ./waf configure --board sitl && ./waf copter

ENV CCACHE_MAXSIZE=1G
ENV PATH /usr/lib/ccache:/ardupilot/Tools:${PATH}
ENV PATH /ardupilot/Tools/autotest:${PATH}
ENV PATH /ardupilot/.local/bin:${PATH}
ENV PATH /ardupilot/jsbsim/build/src:${PATH}
