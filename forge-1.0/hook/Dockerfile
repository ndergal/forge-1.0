FROM richarvey/nginx-php-fpm:1.3.2
WORKDIR /usr/share/nginx/html

ENV WEBROOT /usr/share/nginx/html
ENV PGUSER gitlab
ENV PGPASSWORD password
ENV RUN_SCRIPTS 1

COPY 00-start.sh /var/www/html/scripts/
COPY index.php ./
COPY jenkins.sh ./
COPY redmine.sh ./
COPY redmine.tpl.xml ./
COPY dokuwiki.sh ./
COPY dokuwiki.tpl.json ./

RUN chmod 755 ./*.sh
RUN chown -R nginx ../*
RUN chgrp -R nginx ../*
RUN chown -R root /var/www/html/scripts && chgrp -R root /var/www/html/scripts
