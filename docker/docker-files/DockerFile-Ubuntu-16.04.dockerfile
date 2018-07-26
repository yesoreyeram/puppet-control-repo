FROM ubuntu:16.04

LABEL MAINTAINER Sriramajeyam Sugumaran <yesoreyeram@gmail.com>

RUN apt-get update --yes;
RUN apt-get install -y curl nano git;
RUN curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
RUN dpkg -i puppetlabs-release-pc1-xenial.deb
RUN apt-get update --yes
RUN apt-get -y install puppet-agent
RUN /opt/puppetlabs/puppet/bin/gem install r10k
RUN mkdir -p /etc/puppetlabs/facter/facts.d/

WORKDIR /opt/puppet/