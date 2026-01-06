FROM httpd:2.4

# Activer les modules Apache nécessaires pour PHP-FPM
RUN sed -i \
    -e 's/^#\(LoadModule .*mod_proxy.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_proxy_fcgi.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
    /usr/local/apache2/conf/httpd.conf

# Inclure la configuration du vhost
RUN echo "Include conf/extra/vhost.conf" >> /usr/local/apache2/conf/httpd.conf

# Copier le vhost personnalisé
COPY vhost.conf /usr/local/apache2/conf/extra/vhost.conf

WORKDIR /var/www/html
