# ---------- Build Stage ----------
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files first and install dependencies
COPY app/package*.json ./
RUN npm ci

# Copy application code
COPY app/ .

# Run tests (optional, remove if not needed)
RUN npm test

# ---------- Runtime Stage ----------
FROM node:20-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Install curl for healthcheck
RUN apk add --no-cache curl

# Copy app + node_modules from build stage
COPY --from=build /app /app

# Switch to non-root user
USER appuser

# Expose app port
EXPOSE 3000

# Healthcheck (Alpine + curl)
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD-SHELL "curl -f http://localhost:3000/health || exit 1"

# Start the app
CMD ["npm", "start"]
