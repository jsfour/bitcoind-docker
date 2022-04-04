FROM ubuntu:16.04

ENV VERSION 0.20.0
ENV APP /bitcoin
ENV BUILD_DIR /tmp
RUN mkdir /blockchain &&  mkdir /blockchain/bitcoin
WORKDIR $BUILD_DIR

# Bootstrap basic dependencies & bootstrap apt
RUN	apt-get update \
	&& apt-get -y install curl apt-transport-https software-properties-common \
	&& curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
	&& curl -sL https://deb.nodesource.com/setup_6.x | bash - \
	# && add-apt-repository ppa:bitcoin/bitcoin \
	&& apt-get update

RUN curl -O https://bitcoin.org/bin/bitcoin-core-$VERSION/bitcoin-$VERSION-x86_64-linux-gnu.tar.gz && \
	curl -O https://bitcoin.org/bin/bitcoin-core-$VERSION/SHA256SUMS.asc \
	&& grep bitcoin-$VERSION-x86_64-linux-gnu.tar.gz SHA256SUMS.asc | sha256sum -c -

RUN tar -xzvf bitcoin-$VERSION-x86_64-linux-gnu.tar.gz \
	&& mv bitcoin-$VERSION/bin/* /usr/local/bin

WORKDIR $APP

RUN rm -fr $BUILD_DIR

ENTRYPOINT [ "bitcoind" ]
