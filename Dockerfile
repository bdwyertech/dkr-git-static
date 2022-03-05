FROM alpine:latest as build

RUN apk add git build-base autoconf curl-dev curl-static expat-dev expat-static gettext libssh-dev openssl-dev openssl-libs-static openssl1.1-compat-dev tcl tk zlib-dev zlib-static

RUN git clone --depth 1 -b v2.35.1 https://github.com/git/git.git /git

WORKDIR /git

RUN mkdir /git-static/ \
    && make configure \
    && ./configure prefix=/git-static/ CFLAGS="${CFLAGS} `pkg-config -static -libs libcurl`" \
    && make \
    && make install

FROM alpine:latest

WORKDIR /git-static
COPY --from=build /git-static /git-static/.
