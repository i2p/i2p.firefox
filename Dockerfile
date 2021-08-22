FROM alpine:latest
RUN apk update && apk add firefox make curl musl-locales dbus-x11 font-ubuntu-nerd jq --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
ADD . /src
WORKDIR /src
RUN make profile.tgz # && \
RUN chown -R 1000:1000 /src/build/profile # && \
RUN chmod -R +w /src/build/profile
RUN ls -lah /src/build/profile
#USER 1000
CMD sh -c 'cd build/profile && ./i2pbrowser.sh'