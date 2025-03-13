FROM python:3.11-slim

WORKDIR /app

# Copy the start script
COPY start.sh ./start.sh

# Make the start script executable
RUN chmod +x /app/start.sh

# Environment variables (these will be overridden at runtime)
ENV AIVEN_BASE_URL=https://api.aiven.io
ENV AIVEN_PROJECT_NAME=default
ENV AIVEN_TOKEN=your_token_here

# Expose the port that the server runs on
EXPOSE 8000

# Run the server
CMD ["/app/start.sh"] 