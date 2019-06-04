FROM circleci/python:3.6.5 as build
USER root
COPY . /lodge
WORKDIR /lodge
ENV TZ JST-9
ENV IS_DOCKCER 1
RUN apt-get update && apt-get install -y \
	git \
	vim \
	gcc \
	jq \
	curl \
	make \
	dpkg-sig
RUN alias python3.6='/usr/local/bin/python3.6'
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
CMD ['make', 'all']
