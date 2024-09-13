# Stage 1: Build the Go binary
FROM golang:alpine3.20 AS builder

# Install git (required for fetching dependencies)
RUN apk update && apk add --no-cache git

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod ./

# Download dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o hello-api .

# Stage 2: Create a minimal runtime image
FROM alpine:3.20

# Install ca-certificates (if your app needs to make HTTPS requests)
RUN apk --no-cache add ca-certificates

# Create a non-root user to run the application
RUN adduser -D -h /app -s /bin/sh appuser

# Set the working directory
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/hello-api .

# Change ownership to the non-root user
RUN chown appuser:appuser hello-api

# Switch to the non-root user
USER appuser

# Expose the port your application listens on
EXPOSE 8080

# Command to run the executable
CMD ["./hello-api"]

