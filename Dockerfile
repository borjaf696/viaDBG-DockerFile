FROM ubuntu

#Github download
RUN apt-get update
RUN apt-get install -y git g++ make cmake wget 
RUN apt-get -y install liblzo2-dev liblzma-dev zlib1g-dev build-essential python python-setuptools

# Boost
RUN cd /home && wget http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.gz \
  && tar xfz boost_1_60_0.tar.gz \
  && rm boost_1_60_0.tar.gz \
  && cd boost_1_60_0 \
  && ./bootstrap.sh --prefix=/usr/local --with-libraries=program_options,regex,filesystem,system\
  && ./b2 install \
  && cd /home \
  && rm -rf boost_1_60_0
RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

# BamTools
RUN git clone git://github.com/pezmaster31/bamtools.git && cd bamtools && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/opt/ .. && make DESTDIR=/opt/bamtools install

# SparseHash
RUN git clone https://github.com/justinsb/google-sparsehash.git && cd google-sparsehash
RUN ./configure CXX=g++ CXXFLAGS=-std=c++03 && make && make install

# SGA
RUN mkdir /usr/local/include/bamtools-for-SGA
RUN ln -s /opt/bamtools/opt/include/bamtools/ /usr/local/include/bamtools-for-SGA/include
RUN ln -s /opt/bamtools/opt/lib/ /usr/local/include/bamtools-for-SGA/lib

RUN git clone https://github.com/jts/sga.git
RUN cd sga/src && ./autogen.sh && ./configure --with-bamtools=/usr/local/include/bamtools-for-SGA --with-hoard=/usr/lib64
RUN make && make install

# GitHub download
RUN cd /opt && git clone https://github.com/borjaf696/viaDBG.git viaDBG

# Enter and make
RUN cd /opt/viaDBG && make clean && make
RUN export PATH=$PATH:/opt/viaDBG/bin/

# Creamos carpeta de datos
RUN mkdir /data_noconfio/

# Link al binario
RUN cd /usr/bin && ln -s /opt/viaDBG/bin/viaDBG
RUN viaDBG

# Quast
RUN git clone https://github.com/ablab/quast.git && cd quast && ./setup.py install

## Path to metaquast -> /usr/local/bin/metaquast.py
