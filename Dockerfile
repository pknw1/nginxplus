FROM ubuntu:14.04

MAINTAINER NGINX Docker Maintainers "docker-maint@nginx.com"

# Set the debconf frontend to Noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get install -y -q wget apt-transport-https lsb-release ca-certificates

# Download certificate and key from the customer portal (https://cs.nginx.com)
# and copy to the build context
#ADD nginx-repo.crt /etc/ssl/nginx/
#ADD nginx-repo.key /etc/ssl/nginx/

# Get other files required for installation
RUN wget -q -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
RUN wget -q -O /etc/apt/apt.conf.d/90nginx https://cs.nginx.com/static/files/90nginx

RUN printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" >/etc/apt/sources.list.d/nginx-plus.list

# Install NGINX Plus
#RUN apt-get update && apt-get install -y nginx-plus 1dc79cf0487523f551e6a65ca569fcae



RUN wget https://cs.nginx.com/static/install-nginx && sudo chmod +x install-nginx
RUN sudo ./install-nginx 1041ac5350ec954a9dee481285452cd3

            
# forward request logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
