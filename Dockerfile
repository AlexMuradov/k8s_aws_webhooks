FROM ubuntu:18.04

COPY app /app

ENV NODE_TLS_REJECT_UNAUTHORIZED=0

RUN apt update
RUN apt install nodejs -y && apt install npm -y && \
    apt install nano -y && apt install wget -y && \
    apt install psmisc -y && npm install -g n && \
    n stable
RUN cd /app && npm i ws && openssl genrsa -out key.pem && \
    openssl req -new -key key.pem -out csr.pem \
    -subj "/C=US/ST=Utah/L=Lehi/O=Your Company, Inc./OU=IT/CN=yourdomain.com" && \
    openssl x509 -req -days 9999 -in csr.pem -signkey key.pem -out cert.pem

CMD tail -f /dev/null