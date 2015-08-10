FROM debian:jessie

RUN apt-get update
RUN apt-get install -y cmake libncursesw5-dev libjansson-dev libpq-dev bison flex git xinetd telnetd

RUN git clone https://github.com/ComputerScienceHouse/bingehack4.git /root/bingehack4

RUN mkdir /root/bingehack4-build
RUN cd /root/bingehack4-build && cmake /root/bingehack4
RUN cd /root/bingehack4-build && make
RUN cd /root/bingehack4-build && make install

COPY bingehack-ld.conf /etc/ld.so.conf.d/bingehack-ld.conf
RUN ldconfig

COPY telnet-nethack /root/telnet-nethack
COPY bingehack.xinetd /etc/xinetd.d/nethack
RUN mkdir /root/config /root/nhdata
COPY nhserver.conf /root/config/nhserver.conf

EXPOSE 21

CMD service xinetd start && /root/nethack4/nethack4-data/nethack_server -n -c /root/config/nhserver.conf -w /root/nhdata
