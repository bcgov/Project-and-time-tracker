FROM node:12.14.1

# copy project files and folders to the web directory
COPY . /web

# make the 'web' folder the current working directory
WORKDIR /web

# install project dependencies
RUN npm install


# build app for production with minification
# RUN npm run build
CMD npm run build

# EXPOSE 8080

# CMD [ "npm", "run", "serve" ]