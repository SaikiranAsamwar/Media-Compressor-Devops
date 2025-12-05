# ------------------------------------------------------------
# FRONTEND DOCKERFILE
# Multi-stage Dockerfile to build React frontend and serve with Nginx.
# ------------------------------------------------------------

# ---------- STAGE 1: Build ----------
FROM node:18-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ---------- STAGE 2: Serve ----------
FROM nginx:stable-alpine

# Copy production build to nginx directory
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
