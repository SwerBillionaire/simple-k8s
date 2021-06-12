FROM golang:alpine as base
WORKDIR /build
ENV GO111MODULE=on \
  CGO_ENABLED=0 \
  GOOS=linux \
  GOARCH=amd64
COPY go.mod .
RUN go mod download

FROM base as builder
COPY . .
RUN go build -o main .

FROM alpine:latest as app
WORKDIR /
COPY --from=builder /build .
EXPOSE 3000
CMD ["/main"]
