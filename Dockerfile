# ---------- Build Stage ----------
FROM node:20-alpine AS build
WORKDIR /app

# Copy package.json & package-lock.json
COPY app/package*.json ./

# Install dependencies as root
RUN npm ci

# Copy app code
COPY app/ .

# Optional: run tests
RUN npm test

# ---------- Runtime Stage ----------
FROM node:20-alpine
WORKDIR /app

# Install curl for healthcheck
RUN apk add --no-cache curl

# Copy app and node_modules from build stage
COPY --from=build /app /app

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Fix permissions for non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

EXPOSE 3000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD-SHELL "curl -f http://localhost:3000/health || exit 1"

# Start the app
CMD ["npm", "start"]
