#FROM alpine:3.15
#FROM tatsushid/tinycore:11.0-x86_64
FROM ghcr.io/innovarew/docker-tinycore:13.x-x86_64

ARG password=embtdocker

ENV PA_SERVER_PASSWORD=$password

# TODO : remove this and uncomment similar below
ADD --chown=tc:staff https://altd.embarcadero.com/releases/studio/22.0/113/LinuxPAServer22.0.tar.gz ./tmp/paserver.tar.gz

#RUN apt-get update && \
#     DEBIAN_FRONTEND=noninteractive apt-get -yy install \
#     build-essential \
#     libcurl4-openssl-dev \
#     libcurl3-gnutls \
#     libgl1-mesa-dev \
#     libgtk-3-bin \
#     libosmesa-dev \
#     libpython3.10 \
#     xorg
RUN tce-load -wic python3.9 

RUN tce-load -wic glibc_base-dev 
RUN tce-load -wic glibc_gconv 

RUN tce-load -wic glibc_add_lib 

RUN tce-load -wic glibc_apps 
# RUN tce-load -wic glibc_i18n_locale

# RUN tce-load -wic libGL
# RUN tce-load -wic curl 
# RUN tce-load -wic curl-dev 
# RUN tce-load -wic curlg 
# RUN tce-load -wic curlg-dev
# RUN tce-load -wic gtk3 
# RUN tce-load -wic gtk3-dev 
# RUN tce-load -wic gtk3-gir
# RUN tce-load -wic Xorg-7.7
# RUN tce-load -wic zlib_base-dev

# RUN tce-load -wic coreutils
# RUN tce-load -wic util-linux
# RUN tce-load -wic bash
# RUN tce-load -wic file 

WORKDIR /tmp

### Install PAServer
# ADD --chown=tc:staff https://altd.embarcadero.com/releases/studio/23.0/120/LinuxPAServer23.0.tar.gz ./paserver.tar.gz

RUN tar xvzf paserver.tar.gz
RUN sudo mv PAServer-23.0/* /

WORKDIR /
# link to installed libpython3.10
RUN sudo mv lldb/lib/libpython3.so lldb/lib/libpython3.so_
RUN sudo ln -s /usr/local/lib/libpython3.9.so.1.0 lldb/lib/libpython3.so

COPY --chown=tc:staff --chmod=755 paserver_docker.sh ./paserver_docker.sh
# RUN sudo chmod +x paserver_docker.sh

# Fix "File not found" error. See http://forum.tinycorelinux.net/index.php/topic,26326.0.html
RUN sudo ln -s /lib /lib64

# #=====CLEAN UP==========
RUN rm /tmp/paserver.tar.gz
# #======END CLEAN UP=====

# # PAServer
EXPOSE 64211
# # broadwayd
EXPOSE 8082

CMD ./paserver_docker.sh
# CMD /bin/sh
