# Build do site (Vue 3 + Vite) e entrega como site estático em nginx.
FROM node:22-alpine AS build
WORKDIR /app
COPY FrontEnd/site-cjl/package.json FrontEnd/site-cjl/package-lock.json ./
RUN npm ci
COPY FrontEnd/site-cjl/ ./
RUN npm run build

FROM nginx:alpine
COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf
COPY deploy/headers.conf /etc/nginx/snippets/cjl-headers.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
