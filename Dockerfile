# Pull the minimal Ubuntu image
FROM ubuntu:20.04

# Install Nginx
RUN apt-get -y update && apt-get -y install nginx
# Install http-lua-directive
RUN apt-get -y install libnginx-mod-http-lua

# Copy 9001
COPY  index9001.html /var/www/html/app1/index.html

# Copy 9002
COPY index9002.html /var/www/html/app2/index.html

# Copy 9003
COPY index9003.html /var/www/html/app3/index.html

# Copy the nginx config
COPY nginx.conf /etc/nginx/nginx.conf
# Copy the Nginx default
COPY default /etc/nginx/sites-available/default
# Copy the bash scrip for output
COPY log_counts.sh /log_counts.sh
RUN chmod +x /log_counts.sh

# Expose the port for access
EXPOSE 80/tcp

# Run the Nginx server
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
