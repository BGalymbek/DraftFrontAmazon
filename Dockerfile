#Step 1: Build React App
FROM node:alpine3.18 as build
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

#Step 2 : Server with Nginx
FROM nginx:1.23-alpine
WORKDIR /usr/share/nginx/html
# Установка максимального размера загружаемого файла в Nginx
RUN echo "client_max_body_size 20M;" > /etc/nginx/conf.d/upload.conf

RUN rm -rf *
COPY --from=build /app/build .
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]