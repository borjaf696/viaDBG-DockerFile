FROM ubuntu

#Github download
RUN apt-get update
RUN apt-get install -y git g++ make wget
RUN apt-get -y install liblzo2-dev liblzma-dev zlib1g-dev build-essential python

# Boost
RUN cd /home && wget http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.gz \
  && tar xfz boost_1_60_0.tar.gz \
  && rm boost_1_60_0.tar.gz \
  && cd boost_1_60_0 \
  && ./bootstrap.sh --prefix=/usr/local --with-libraries=program_options,regex,filesystem,system\
  && ./b2 install \
  && cd /home \
  && rm -rf boost_1_60_0

# GitHub download
RUN cd /opt && git clone https://github.com/borjaf696/viaDBG.git viaDBG

# Enter and make
RUN cd /opt/viaDBG && make clean && make
RUN export PATH=$PATH:/opt/viaDBG/bin/

