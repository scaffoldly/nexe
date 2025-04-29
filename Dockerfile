ARG NODE_VERSION=20
FROM node:${NODE_VERSION} AS warm
WORKDIR /work
COPY . .
RUN --mount=type=cache,target=/root/.nexe \
    yarn && \
    yarn build --python=$(which python3) && \
    ./dist/is-warm

FROM node:${NODE_VERSION}
COPY --from=warm /root/.nexe /root/.nexe
