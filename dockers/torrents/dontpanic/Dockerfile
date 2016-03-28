FROM httpd:2.4

VOLUME /tmp

# - Install package for python3 and php5
RUN apt-get update \
    && apt-get upgrade -y -q \
    \
    && \
    \
    apt-get -y install git locales mc \
               python3-cherrypy3 libapache2-mod-wsgi-py3 \
               python3-bs4 python3-libtorrent python3-requests python3-bottle \
               sqlite3 gettext \
               php5 php5-cgi \
    && \
    ln -s /usr/lib/apache2/modules/libphp5.so /usr/local/apache2/modules/mod_php5.so \
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


# - Clone dontpanic
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

# - Patch some dontpanic issue
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
      && \
      sed -i -e "9 s|</h1>|</h1><h4><a href='/elfinder/elfinder.html'>Files</a></h4>|" \
             views/towel.tpl \
    )

# - Add wsgi capability to dontpanic
COPY ./dontpanic-server.wsgi /usr/local/apache2/cgi-bin/dontpanic/dontpanic-server.wsgi

# - Copy dontpanic config
ADD .dontpanic /usr/local/apache2/cgi-bin/dontpanic/.dontpanic
RUN ( cd /usr/local/apache2/cgi-bin/dontpanic/ \
      && chown -R daemon:daemon .dontpanic \
      && mkdir -p /var/run/apache2 \
      && chmod 777 /var/run/apache2 \
    )

# - Needed by dontpanic
WORKDIR /usr/local/apache2/cgi-bin/dontpanic/

# - Set locale (needed by dontpanic)
ENV LC_ALL="en_US.UTF-8"  LANG="en_US.UTF-8"  LANGUAGE="en_US:en"  TERM="xterm"



##########################
# ELFINDER
##########################


# - download elfinder setting minimal connector
RUN ( \
      cd /usr/local/apache2/cgi-bin/ \
      && git clone https://github.com/Studio-42/elFinder.git elfinder \
      && ( cd elfinder \
          && git checkout 2.1.9 \
          && cp php/connector.minimal.php-dist php/connector.minimal.php \
          && chmod +x php/connector.minimal.php \
          && sed -i -e "1 s|<?php|#!/usr/bin/php5-cgi\n\n<?php|" \
                    php/connector.minimal.php \
          && rm -rf files && ln -s /tmp files \
         ) \
      && chown -R daemon:daemon elfinder \
    )

# - big security hole 
RUN echo "" >> /etc/php5/cgi/php.ini \
    && echo "" >> /etc/php5/cgi/php.ini \
    && echo "cgi.force_redirect = 0" >> /etc/php5/cgi/php.ini 


# - Copy apache httpd config for dontpanic and elfinder
COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf




