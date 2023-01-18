FROM registry.access.redhat.com/ubi8/nginx-118
# support running as arbitrary user which belogs to the root group
# RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# users are not allowed to listen on priviliged ports
# RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
# EXPOSE 8081
# comment user directive as master process is run as user in OpenShift anyhow
# RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
# COPY ./dist /app



# COPY nginx.conf.template /etc/nginx/conf.d


# COPY ./dist/ /usr/share/nginx/html/timemachine
# ENV NGINX_SERVER_PORT=8081
# ENV NGINX_SERVER_NAME=localhost
# RUN envsubst < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/default.conf


# https://catalog.redhat.com/software/containers/ubi8/nginx-118/5f521a6f9dd2d5ca7158e5dc?gti-tabs=get-the-source&container-tabs=overview
# ADD nginx.conf "${NGINX_CONF_PATH}"
# ADD ./dist .
# Run script uses standard ways to run the application
# CMD nginx -g "daemon off;"

# https://catalog.redhat.com/software/containers/ubi8/nginx-118/5f521a6f9dd2d5ca7158e5dc?gti-tabs=get-the-source&container-tabs=overview
# Add application sources to a directory that the assemble script expects them
# and set permissions so that the container runs without root access
# USER 0
# ADD ./dist /tmp/src/
# RUN chown -R 1001:0 /tmp/src
# USER 1001

# # Let the assemble script to install the dependencies
# RUN /usr/libexec/s2i/assemble

# # Run script uses standard ways to run the application
# CMD /usr/libexec/s2i/run

# Add application sources
# ADD ./nginx.conf "${NGINX_CONF_PATH}"


# TODO - Choose between one of copy/add
# TODO - SHOULD ONLY NEED ONE
# ADD ./dist .    
ADD ./dist /usr/share/nginx/html/timemachine    
# COPY dist /opt/app-root/src

ADD nginx.conf "${NGINX_CONF_PATH}"

# ADD test-app/*.html .


EXPOSE 8080

# Run script uses standard ways to run the application
CMD nginx -g "daemon off;"


