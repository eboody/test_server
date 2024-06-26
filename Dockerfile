FROM rust:latest AS builder

WORKDIR /app

COPY . .

ENV RUST_MIN_STACK=16777216

RUN cargo build --release

FROM debian:bookworm-slim

RUN apt-get update && \
  apt-get install -y curl wget openssl ca-certificates && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/target/release/test_server .
COPY --from=builder /app/web-folder ./web-folder

# Expose the port that the app runs on
EXPOSE 3000

# Run the binary
CMD ["./test_server"]
