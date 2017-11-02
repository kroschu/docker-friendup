FROM debian:jessie

MAINTAINER Jens Rabe <schaumwaffelpilot@googlemail.com>

# Some preparations
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y dist-upgrade

# Install the dependencies
RUN apt-get -y install git-core libssh2-1-dev libssh-dev libssl-dev libaio-dev \
        php5-cli php5-curl php5-mysql php5-gd php5-imap \
        libmysqlclient-dev build-essential libmatheval-dev libmagic-dev \
        libgd-dev libwebsockets-dev rsync valgrind-dbg libxml2-dev php5-readline \
        cmake sudo mysql-client \
        libsqlite3-dev libsmbclient-dev libssh2-1-dev libssh-dev libaio-dev \
        ssh curl build-essential python

# We'll run this with a normal user.
RUN adduser friend

# The user must have passwordless sudo rights for the installation to succeed
RUN echo "friend:friend" |chpasswd
RUN adduser friend sudo
ADD friend /etc/sudoers.d/
RUN visudo -c -f /etc/sudoers.d/friend

# Now, let's become the new user,
USER friend
WORKDIR /home/friend
ENV HOME /home/friend

# Get the source code
RUN git clone https://github.com/FriendSoftwareLabs/friendup
WORKDIR /home/friend/friendup

# Compile everything
RUN make setup
RUN make clean setup release install

# Put the startup script into the run directory
WORKDIR /home/friend/friendup/build
ADD docker-friendup.sh /home/friend/friendup/build/
RUN sudo chmod +x docker-friendup.sh

# Have it run when the container starts.
CMD ./docker-friendup.sh

# Defaults
ENV DB_HOST=friendupdb
ENV DB_PORT=3306
ENV DB_NAME=friendup
ENV DB_USER=friendup
ENV DB_PASS=friendup

# Not only 6502 is needed, there are some additional ports that need to be
# exposed, too, otherwise, there will be warnings about disconnects.
EXPOSE 6500-6504
