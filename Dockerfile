FROM golang:1.19 as builder
ENV GOPATH /gopath/
ENV PATH $GOPATH/bin/$PATH

RUN go version
RUN  go env -w GOPROXY=https://goproxy.io,direct
RUN  go env -w GO111MODULE=on

COPY . /go/src/blackbox_exporter/
WORKDIR /go/src/blackbox_exporter/

RUN make build


FROM k8s.gcr.io/debian-base:v2.0.0

COPY --from=builder /go/src/blackbox_exporter /

EXPOSE      9115
ENTRYPOINT  [ "/blackbox_exporter" ]
CMD         [ "--config.file=/etc/blackbox_exporter/config.yml" ]
