# Use an official Nginx image as a base
FROM nginx:latest

# Copy custom configuration files
COPY ./nginx/conf.d /etc/nginx/conf.d
COPY ./nginx/cert /etc/nginx/cert
COPY ./nginx/cert/private /etc/nginx/cert/private

# Expose ports
EXPOSE 80 443

# Default command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
