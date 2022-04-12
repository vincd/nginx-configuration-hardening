# docker build --no-cache -t nginx-image:latest .
# docker rm --force `docker ps --no-trunc -aq --filter "name=nginx-test-hardening"`
# docker run -d -p 8000:80 --name nginx-test-hardening nginx-image

FROM ubuntu:20.04

LABEL maintainer="vincent@unbonhacker.com"
LABEL version="1.0"
LABEL description="Docker from blog post: https://unbonhacker.com/posts/nginx-configuration-hardening"

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Install nginx and Python3
RUN apt update
RUN apt-get install -y python python3-pip python3-virtualenv nginx gunicorn supervisor

# Setup flask application
RUN mkdir -p /opt/app
COPY app /opt/app
RUN pip install -r /opt/app/requirements.txt

# Setup nginx
RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Setup supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose Port 80 for application
EXPOSE 80

# Start processes
CMD ["/usr/bin/supervisord"]
