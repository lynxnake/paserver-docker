FROM ghcr.io/innovarew/docker-tinycore:14.x-x86_64

ARG password=embtdocker

ENV PA_SERVER_PASSWORD=$password

RUN tce-load -wic python3.9 
RUN tce-load -wic glibc_gconv 

### Install PAServer
WORKDIR /tmp
ADD --chown=tc:staff https://altd.embarcadero.com/releases/studio/23.0/120/LinuxPAServer23.0.tar.gz ./paserver.tar.gz
RUN tar xvzf paserver.tar.gz
RUN sudo mv PAServer-23.0/* /
RUN rm /tmp/paserver.tar.gz

WORKDIR /

# link to installed libpython
RUN sudo mv lldb/lib/libpython3.so lldb/lib/libpython3.so_
RUN sudo ln -s /usr/local/lib/libpython3.9.so.1.0 lldb/lib/libpython3.so

COPY --chown=tc:staff --chmod=755 paserver_docker.sh ./paserver_docker.sh

# Fix "File not found" error. See http://forum.tinycorelinux.net/index.php/topic,26326.0.html
RUN sudo ln -s /lib /lib64

# # PAServer
EXPOSE 64211
# # broadwayd
EXPOSE 8082

CMD ./paserver_docker.sh