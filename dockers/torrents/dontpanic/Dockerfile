FROM httpd:2.4

VOLUME /tmp

RUN apt-get update \
    && apt-get upgrade -y -q \
    \
    && \
    \
    apt-get -y install git locales mc \
               python3-cherrypy3 libapache2-mod-wsgi-py3 \
               python3-bs4 python3-libtorrent python3-requests python3-bottle \
               sqlite3 gettext \
    && \
    ln -s /usr/lib/apache2/modules/mod_wsgi.so /usr/local/apache2/modules/mod_wsgi.so \
    && \
    \
    locale-gen en_US.UTF-8 \
    \
    \
    \
    && apt-get upgrade -y \
    && apt-get clean -y  \
    && apt-get autoclean -y  \
    && apt-get autoremove -y  \
    && rm -rf /usr/share/locale/*  \
    && rm -rf /var/cache/debconf/*-old  \
    && rm -rf /var/lib/apt/lists/*  \
    && rm -rf /usr/share/doc/*


RUN ( \
      cd /usr/local/apache2/cgi-bin/ \
      && git clone https://git.framasoft.org/Thuban/dontpanic.git \
      && ( cd dontpanic && git checkout 6b5fe00 ) \
      && chown -R daemon:daemon dontpanic \
      && chmod +x dontpanic/dontpanic-server.py \
    ) \
    \
    \
    && ln -s /usr/bin/python3 /usr/bin/python 

RUN ( cd /usr/local/apache2/cgi-bin/dontpanic/ \
      && \
      sed -i -e \
      's|confdir = os.pa.*|confdir=os.path.join("/usr/local/apache2/cgi-bin/dontpanic/")|' \
             utils.py \
      && \
      sed -i -e "s|open(output, 'w')|open(output, 'wb')|" \
             -e "s|output.write(r)|output.write(r.encode(errors='ignore'))|" \
             subtitle.py \
      && \
      sed -i -e "747 s|{}||" \
             dontpanic.py \
    )


COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf

COPY ./dontpanic-server.wsgi /usr/local/apache2/cgi-bin/dontpanic/dontpanic-server.wsgi
ADD .dontpanic /usr/local/apache2/cgi-bin/dontpanic/.dontpanic
RUN ( cd /usr/local/apache2/cgi-bin/dontpanic/ \
      && chown -R daemon:daemon .dontpanic \
      && mkdir -p /var/run/apache2 \
      && chmod 777 /var/run/apache2 \
    )


ENV LC_ALL="en_US.UTF-8"  LANG="en_US.UTF-8"  LANGUAGE="en_US:en"  TERM="xterm"


WORKDIR /usr/local/apache2/cgi-bin/dontpanic


