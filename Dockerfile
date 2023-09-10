FROM  alpine/git:latest AS frontend-loader
ARG  FRONTEND_URI
WORKDIR  /data
RUN  git clone --branch master ${FRONTEND_URI} project

FROM  node:18.17.1 AS frontend-builder
WORKDIR  /data
COPY  --from=frontend-loader /data/project .
RUN  npm install
RUN  npm run build

FROM  nginx:latest
WORKDIR  /usr/share/nginx/html
COPY  --from=frontend-builder /data/build .

