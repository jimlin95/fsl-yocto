# ===========================================================================================
# Dockerfile for building the Yocto Project
# 
# References:
#	http://www.yoctoproject.org/docs/current/yocto-project-qs/yocto-project-qs.html
# ===========================================================================================

FROM ubuntu:14.04.3

MAINTAINER Jim Lin <jim_lin@quantatw.com>

# Make sure the package repository is up to date
RUN apt-get update
RUN apt-get -y upgrade

# Install packages we cannot leave without...
RUN apt-get install -y git openssh-server
#RUN apt-get install -y mc
#RUN apt-get install -y openssh-server
# Make sure the directory exists, otherwise sshd will not start
RUN mkdir -p /var/run/sshd
#RUN apt-get install -y screen

# Install the following utilities (required by poky)
RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath libsdl1.2-dev xterm

# Install the following utilities (required later)
RUN apt-get install -y curl

# Install the following utilities (required by hob)
RUN apt-get install -y python-gobject python-gtk2

#
# # Install "repo" tool
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
RUN chmod a+x /usr/local/bin/repo

ADD .gitconfig /home/work/
# Additional host packages required by poky/scripts/wic
# TODO: Understand how to build them using the -native recipes
#RUN apt-get install -y parted dosfstools mtools syslinux

# NOTE: Uncomment if user "work" is not already created inside the base image
## Create non-root user that will perform the work of the images
RUN useradd --shell /bin/bash work
RUN mkdir -p /home/work
RUN chown -R work /home/work
RUN adduser work sudo
RUN echo work:work | chpasswd
RUN mkdir -p /src

# TODO: Run as user "build" once Docker supports user-level volumes
#RUN su -c "mkdir -p ~/yocto" build
#RUN su -c "cd ~ && git clone git://git.yoctoproject.org/poky" build
#ENTRYPOINT ["/bin/su", "-l", "build"]

# For the time being, let us install and run poky as root
ENTRYPOINT ["/bin/bash"]

# Expose sshd port
EXPOSE 22

# EOF
