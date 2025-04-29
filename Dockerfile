ARG NODE_VERSION=20
FROM node:${NODE_VERSION} AS warm
WORKDIR /work
COPY . .
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    libc6-arm64-cross \
    libc6-amd64-cross
RUN --mount=type=cache,target=/root/.nexe \
    yarn && \
    yarn build --python=$(which python3) && \
    ./dist/is-warm

FROM node:${NODE_VERSION}
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    libc6-arm64-cross \
    libc6-amd64-cross
COPY --from=warm /root/.nexe /root/.nexe
