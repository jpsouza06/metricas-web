FROM node:18.18.0-alpine AS builder
RUN mkdir /metricas-web
WORKDIR /metricas-web
COPY . .
ARG BASEURL
ENV API_BASE_URL=${BASEURL}
RUN npm install
RUN npm run build

ENTRYPOINT ["/bin/sh", "./docker-entrypoint.sh"]