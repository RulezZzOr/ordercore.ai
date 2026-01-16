# Build stage
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Install dependencies
RUN apk add --no-cache git ca-certificates

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copy source
COPY . .

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /ordercore ./cmd/api

# Runtime stage
FROM gcr.io/distroless/static-debian12

COPY --from=builder /ordercore /ordercore

# Cloud Run uses PORT env var
ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["/ordercore"]
