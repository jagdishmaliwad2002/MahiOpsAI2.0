# -------- Build Stage --------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY app/package*.json ./

# Install ALL dependencies (including dev)
RUN npm install --include=dev

# Copy full code
COPY app/ .

# Build project
RUN npm run build


# -------- Runtime Stage --------
FROM node:20-alpine

WORKDIR /app

# Copy built files only
COPY --from=builder /app .

# Set production mode
ENV NODE_ENV=production

EXPOSE 5000

# Run production server
CMD ["npm","start"]
