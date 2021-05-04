FROM nginx:stable
# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8081
# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
COPY ./dist /app
COPY nginx.conf.template /etc/nginx/conf.d


COPY ./dist/ /usr/share/nginx/html/timemachine
ENV NGINX_SERVER_PORT=8081
ENV NGINX_SERVER_NAME=localhost

RUN envsubst < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/default.conf