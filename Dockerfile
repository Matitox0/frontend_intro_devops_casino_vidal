# ---------- Etapa builder: compilar Angular ----------
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---------- Etapa runtime: Nginx sin root ----------
FROM nginxinc/nginx-unprivileged AS runtime
USER root
RUN rm -rf /usr/share/nginx/html/*
USER nginx
COPY default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=builder /app/dist/casino-frontend/browser/. /usr/share/nginx/html/
EXPOSE 8080