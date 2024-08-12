# Use the official Nginx image from the Docker Hub
FROM nginx:latest

RUN groupadd -r myuser && useradd -r -g myuser myuser
RUN chown -R myuser:myuser /var/cache/nginx /var/log/nginx /etc/nginx /usr/share/nginx/html

USER myuser

EXPOSE 80 443

COPY ./nginx/conf.d /etc/nginx/conf.d
COPY ./nginx/cert /etc/nginx/cert
# COPY ./nginx/cert/private /etc/nginx/cert/private
