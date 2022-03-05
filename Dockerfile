FROM alpine:latest as build

RUN apk add git build-base autoconf curl-dev curl-static expat-dev gettext openssl-dev openssl1.1-compat-dev tcl tk zlib-dev zlib-static

RUN git clone --depth 1 -b v2.35.1 https://github.com/git/git.git /git

WORKDIR /git

RUN mkdir /git-static/ \
    && make configure \
    && ./configure prefix=/git-static/ CFLAGS="${CFLAGS} -static" \
    && make \
    && make install

FROM alpine:latest

WORKDIR /git-static
COPY --from=build /git-static /git-static/.
