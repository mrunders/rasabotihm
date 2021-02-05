# Dockerfile
FROM node:11.13.0-alpine

# create destination directory
WORKDIR /nodebot

# update and install dependency
RUN apk update && apk upgrade
RUN apk add git

# copy the app, note .dockerignore
COPY . /nodebot
RUN npm install

EXPOSE 5000

ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=5000

CMD [ "npm", "run", "dev", "--port", "5000" ]