FROM node:20-alpine
WORKDIR /app

# Install curl for healthcheck
RUN apk add --no-cache curl

# Copy app + node_modules from build stage
COPY --from=build /app /app

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Fix permissions
RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 3000

# Healthcheck compatible with all Docker versions
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD sh -c "curl -f http://localhost:3000/health || exit 1"

CMD ["npm", "start"]
