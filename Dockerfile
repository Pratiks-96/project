# ---------- Build Stage ----------

FROM node:20-alpine AS build
WORKDIR /app
COPY app/package*.json ./
RUN npm ci
COPY app/ .
RUN npm test

# ---------- Runtime Stage ----------

FROM node:20-alpine
WORKDIR /app

# Create non-root user

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=build /app /app

USER appuser
EXPOSE 3000

# Healthcheck (fixed syntax)

HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD curl -f [http://localhost:3000/health](http://localhost:3000/health) || exit 1

CMD ["npm", "start"]
