FROM node:8.15-alpine

LABEL mantainer="Jesus Dominguez j.dominguez@kodeline.com"

ARG GULP_RUN_SCRIPT
ARG GULP_REPOSITORY

ENV RUN_SCRIPT=${GULP_RUN_SCRIPT}
ENV GULP_REPOSITORY=${GULP_REPOSITORY}
ENV TOOLSET_FOLDER=/app-front-tools

RUN apk add --no-cache --virtual .build-deps-yarn vim wget

RUN mkdir -p ${TOOLSET_FOLDER} \ && wget -qO- ${GULP_REPOSITORY} | tar -xzvf - -C ${TOOLSET_FOLDER} --strip-components 1

RUN npm install -g gulp browser-sync

WORKDIR ${TOOLSET_FOLDER}

RUN npm install

#CMD ["gulp"]
CMD ["tail", "-f", "/dev/null"]