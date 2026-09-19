FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV STA_HOME=/opt/OpenSTA
ENV PATH=/opt/OpenSTA/build:/usr/local/bin:$PATH

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/bash ${USERNAME} \
    && apt-get update \
    && apt-get install -y --no-install-recommends sudo \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       autoconf automake autotools-dev bison build-essential ca-certificates \
       cmake curl flex libfl-dev gawk gdb git libeigen3-dev libfmt-dev libgtest-dev \
       make m4 ninja-build pkg-config swig tcl tcl-dev tcl-tclreadline \
       wget zlib1g-dev \
       xfce4 xfce4-terminal x11vnc xvfb novnc websockify supervisor dbus-x11 \
       yosys iverilog gtkwave \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Build CUDD 3.0.0
RUN wget -q https://raw.githubusercontent.com/davidkebo/cudd/main/cudd_versions/cudd-3.0.0.tar.gz \
    && tar -xzf cudd-3.0.0.tar.gz \
    && rm cudd-3.0.0.tar.gz \
    && cd cudd-3.0.0 \
    && ./configure --prefix=/opt/cudd \
    && make -j"$(nproc)" \
    && make install \
    && rm -rf /cudd-3.0.0

# Build OpenSTA
ARG OPENSTA_REF=master

RUN git clone --depth 1 --branch ${OPENSTA_REF} \
      https://github.com/The-OpenROAD-Project/OpenSTA.git ${STA_HOME} \
    && cmake -S ${STA_HOME} -B ${STA_HOME}/build \
       -DCUDD_DIR=/opt/cudd \
       -DBUILD_TESTS=OFF \
       -DUSE_TCL_READLINE=OFF \
       -DCMAKE_BUILD_TYPE=Release \
    && cmake --build ${STA_HOME}/build --target sta -j"$(nproc)" \
    && install -m 0755 ${STA_HOME}/build/sta /usr/local/bin/sta \
    && ln -s ${STA_HOME}/examples /opt/opensta-examples

COPY supervisord.conf /etc/supervisor/conf.d/vnc.conf

EXPOSE 6080

CMD ["/usr/bin/supervisord", "-n"]
