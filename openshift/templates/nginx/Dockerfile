FROM nginx:stable

RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# users are not allowed to listen on priviliged ports
# RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8081
# comment user directive as master process is run as user in OpenShift anyhow
# RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
COPY ./nginx.conf.template /etc/nginx/nginx.conf


WORKDIR /code

COPY ./dist .

EXPOSE 8080:8080

CMD ["nginx", "-g", "daemon off;"]