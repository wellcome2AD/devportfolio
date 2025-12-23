# Stage 1: Build
FROM node:20-alpine AS builder
# Установка рабочей директории
WORKDIR /app
# Копирование файлов зависимостей
COPY package*.json ./
# Установка зависимостей (включая devDependencies для сборки)
RUN npm ci
# Копирование исходного кода
COPY . .
# Сборка проекта
RUN npm run build
# Stage 2: Production
FROM nginx:alpine
# Копирование конфигурации nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Копирование собранных файлов из builder stage
COPY --from=builder /app/dist /usr/share/nginx/html
# Healthcheck для мониторинга
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
 CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1
# Порт приложения
EXPOSE 80
# Запуск nginx в foreground режиме
CMD ["nginx", "-g", "daemon off;"]