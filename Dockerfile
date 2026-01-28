# ---------- Build Stage ----------
FROM node:20-alpine AS build
WORKDIR /app

# Copy package files first and install dependencies
COPY app/package*.json ./
RUN npm ci

# Copy application code
COPY app/ .

# Optional: run tests
RUN npm test

# ---------- Runtime Stage ----------
FROM node:20-alpine
WORKDIR /app

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy application and node_modules from build stage
COPY --from=build /app /app

# Switch to non-root user
USER appuser

EXPOSE 3000

# Healthcheck
HEALTHCHECK --interva
