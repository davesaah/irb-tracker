# -------- Build stage --------
FROM golang:1.26 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o app .

# -------- Runtime stage --------
FROM alpine:3.23

WORKDIR /app

RUN adduser -D appuser
USER appuser

COPY --from=builder /app/app .

EXPOSE 42069

CMD ["./app"]
