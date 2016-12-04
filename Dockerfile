FROM ubuntu:14.04

###############################################################
# BASIC STUFF
###############################################################

RUN apt-get update -y
RUN apt-get install -y wget git build-essential openssl libssl-dev pkg-config python

###############################################################
# COMPILE AND INSTALL NODEJS, NPM AND BOWER
###############################################################

WORKDIR /root
RUN wget http://nodejs.org/dist/v0.12.6/node-v0.12.6.tar.gz
RUN tar -xzf node-v0.12.6.tar.gz

WORKDIR /root/node-v0.12.6
RUN ./configure
RUN make
RUN make install

RUN apt-get install -y npm
RUN npm install pm2 -g

RUN npm install bower -g
RUN echo '{ "allow_root": true }' > /root/.bowerrc

###############################################################
# DOWNLOAD PROJECT
###############################################################

WORKDIR /root/
RUN git clone https://github.com/zepspaiva/socket.io-server

###############################################################
# RUN PROJECT
###############################################################

WORKDIR /root/socket.io-server
RUN npm install

EXPOSE 80
CMD ["/bin/sh", "-c", "node socketio-server.js --port 80 > /root/socketio.log 2>&1"]