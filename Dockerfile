# Dockerfile for building the containerized poller_exporter
# golang:1.18 as of 2022-07-04
FROM golang@sha256:820153096fda4de6ac1b7194d12e416b7dd8f4e9a33d17e0345b111b945162d8 AS build

MAINTAINER William Rouesnel <wrouesnel@wrouesnel.com>
EXPOSE 9115

COPY ./ /workdir/
WORKDIR /workdir

RUN go run mage.go binary

FROM scratch

MAINTAINER Will Rouesnel <wrouesnel@wrouesnel.com>

ENV PATH=/bin
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs
COPY --from=build /workdir/reverse_exporter /bin/reverse_exporter
COPY /reverse_exporter.yml /config/reverse_exporter.yml

ENTRYPOINT ["/bin/reverse_exporter"]
CMD ["--log-format=json"]
