#Step 1: Build React App
FROM node:alpine3.18 as build
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

#Step 2 : Server with Nginx
FROM nginx:1.23-alpine

# Копирование основного конфигурационного файла Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Установка максимального размера загружаемого файла в Nginx
RUN sed -i 's/http {/http {\n    client_max_body_size 100M;/g' /etc/nginx/nginx.conf

WORKDIR /usr/share/nginx/html

# Очистка содержимого папки html
RUN rm -rf *

# Копирование собранного React-приложения в директорию html Nginx
COPY --from=build /app/build .

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
