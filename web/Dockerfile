# FIRST STAGE OF MULTI-STAGE BUILD: BUILD APPLICATION

FROM node:8.11.1
COPY . /web
WORKDIR /web
# RUN npm install
RUN npm cache clean --force && npm install
RUN npm run build

# SECOND STAGE OF MULTI-STAGE BUILD:  HOST OUTPUT FROM STAGE1 W/ NGINX

FROM nginx:latest
WORKDIR /app/
COPY nginx.conf.template /etc/nginx/nginx.conf
COPY --from=0 /web/dist .