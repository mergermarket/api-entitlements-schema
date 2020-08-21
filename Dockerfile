FROM node:lts-slim

RUN npm install -g ajv-cli

ENTRYPOINT [ "ajv" ]