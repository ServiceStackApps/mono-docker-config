FROM ubuntu:14.04

MAINTAINER Sergey Zhukov svg@ngs.ru

#create directories
WORKDIR "/home"
RUN mkdir -p hfc-install && cd hfc-install && mkdir -p config

ENV USERHFCPORT 9000
ENV USERSITE www.test.com
ENV USERLOCATION /var/www/hello-app

WORKDIR "/home/hfc-install"
#getting templates
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN sudo apt-get -qqq update && sudo apt-get install -y curl
RUN curl -sL https://github.com/ServiceStackApps/mono-server-config/raw/master/nginx-config/hello-app.conf.tpl -o config/hello-app.conf.tpl
RUN curl -sL https://github.com/ServiceStackApps/mono-server-config/raw/master/hfc-config/hfc.config.tpl -o config/hfc.config.tpl

RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
RUN echo "Updating repositories..."
RUN sudo apt-get -qqq update
RUN echo "Installing mono..."
RUN sudo apt-get install -y -q mono-complete
#installing nginx
RUN echo "Installing nginx..."
RUN sudo apt-get install -y nginx
#installing HyperFastCGI
RUN echo "Installing HyperFastCGI"
#libtool-bin is required by Ubuntu 15.10 This package does not exist in Ubuntu 14.04 and lower
RUN sudo apt-get install -y git autoconf automake libtool make libglib2.0-dev libevent-dev
RUN git clone https://github.com/xplicit/hyperfastcgi
#double call for autogen.sh Workaround for weird error 'cannot find Makefile.in' while writing config.status
WORKDIR "/home/hfc-install/hyperfastcgi"
RUN ./autogen.sh --prefix=/usr || true
RUN ./autogen.sh --prefix=/usr && make && sudo make install
#RUN cd ..

EXPOSE 80
VOLUME ["/var/www"]

WORKDIR "/home"
COPY entrypoint.sh entrypoint.sh
RUN chmod a+x entrypoint.sh
ENTRYPOINT "/home/entrypoint.sh"