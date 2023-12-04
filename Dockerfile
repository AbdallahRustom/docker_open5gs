FROM oaisoftwarealliance/oai-upf-vpp:v1.4.0

COPY x y  

apt install -y apt install tcpdump iproute2 

WORKDIR /openair-upf

#expose
EXPOSE 8085/udp 2152/udp

ENTRYPOINT ["/openair-upf/bin/entrypoint.sh"]
CMD ["/openair-upf/run.sh"]

