FROM alpine:latest as openssl_1_0_2p
RUN apk --no-cache add bash autoconf gcc g++ make wget tar perl zlib zlib-dev coreutils git
RUN mkdir -p /tmp/workspace/sources
RUN wget "https://www.openssl.org/source/openssl-1.0.2p.tar.gz" -qO- | \
    tar --extract --gzip --directory=/tmp/workspace/sources/
RUN git clone "https://github.com/openssh/openssh-portable" /tmp/workspace/sources/openssh-portable
RUN echo "cloned openssh repo at:" && \
    git -C /tmp/workspace/sources/openssh-portable rev-parse --verify HEAD
RUN apk del libressl2.7-libcrypto libressl2.7-libtls libressl2.7-libssl wget ssl_client git apk-tools
RUN cd /tmp/workspace/sources/openssl-1.0.2p && \
    ./config enable-camellia enable-ec enable-asm \
             enable-zlib --prefix=/usr/local \
             --openssldir=/etc/ssl --libdir=lib \
             shared threads && \
    make depend && make && make install
RUN cd /tmp/workspace/sources/openssh-portable && \
    autoreconf --install && \
    ./configure --sysconfdir=/etc/ssh \
               --libexecdir=/usr/lib/misc \
               --datadir=/usr/share/openssh \
               --with-pie --with-openssl \
               --with-md5-passwords \
               --with-ssl-engine && \
    make && make install

FROM alpine:latest as openssl_1_0_2o
RUN apk --no-cache add bash autoconf gcc g++ make wget tar perl zlib zlib-dev coreutils git
RUN mkdir -p /tmp/workspace/sources
RUN wget "https://www.openssl.org/source/old/1.0.2/openssl-1.0.2o.tar.gz" -qO- | \
    tar --extract --gzip --directory=/tmp/workspace/sources/
RUN git clone "https://github.com/openssh/openssh-portable" /tmp/workspace/sources/openssh-portable
RUN echo "cloned openssh repo at:" && \
    git -C /tmp/workspace/sources/openssh-portable rev-parse --verify HEAD
RUN apk del libressl2.7-libcrypto libressl2.7-libtls libressl2.7-libssl wget ssl_client git apk-tools
RUN cd /tmp/workspace/sources/openssl-1.0.2o && \
    ./config enable-camellia enable-ec enable-asm \
             enable-zlib --prefix=/usr/local \
             --openssldir=/etc/ssl --libdir=lib \
             shared threads && \
    make depend && make && make install
RUN cd /tmp/workspace/sources/openssh-portable && \
    autoreconf --install && \
    ./configure --sysconfdir=/etc/ssh \
               --libexecdir=/usr/lib/misc \
               --datadir=/usr/share/openssh \
               --with-pie --with-openssl \
               --with-md5-passwords \
               --with-ssl-engine && \
    make && make install

FROM alpine:latest
RUN apk --no-cache add bash autoconf zlib coreutils grep sed
RUN mkdir -p /tmp/workspace/openssh_openssl_1_0_2o
COPY --from=openssl_1_0_2o /usr/local/bin/ssh /tmp/workspace/openssh_openssl_1_0_2o
COPY --from=openssl_1_0_2o /usr/local/bin/ssh-keygen /tmp/workspace/openssh_openssl_1_0_2o
COPY --from=openssl_1_0_2o /usr/local/bin/openssl /tmp/workspace/openssh_openssl_1_0_2o
COPY --from=openssl_1_0_2o /usr/local/lib/libcrypto.so.1.0.0 /tmp/workspace/openssh_openssl_1_0_2o
COPY --from=openssl_1_0_2o /usr/local/lib/libssl.so.1.0.0 /tmp/workspace/openssh_openssl_1_0_2o
RUN mkdir -p /tmp/workspace/openssh_openssl_1_0_2p
COPY --from=openssl_1_0_2p /usr/local/bin/ssh /tmp/workspace/openssh_openssl_1_0_2p
COPY --from=openssl_1_0_2p /usr/local/bin/ssh-keygen /tmp/workspace/openssh_openssl_1_0_2p
COPY --from=openssl_1_0_2p /usr/local/bin/openssl /tmp/workspace/openssh_openssl_1_0_2p
COPY --from=openssl_1_0_2p /usr/local/lib/libcrypto.so.1.0.0 /tmp/workspace/openssh_openssl_1_0_2p
COPY --from=openssl_1_0_2p /usr/local/lib/libssl.so.1.0.0 /tmp/workspace/openssh_openssl_1_0_2p
COPY find_key_failure.sh /tmp/workspace
COPY find_misleading_msg.sh /tmp/workspace
COPY tester.sh /tmp/workspace
WORKDIR /tmp/workspace
ENTRYPOINT ["/tmp/workspace/tester.sh"]
