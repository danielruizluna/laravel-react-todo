FROM node:18.3-alpine AS assets-build
WORKDIR /app
COPY . /app

RUN npm install
RUN npm audit fix
RUN npm install react@18.3.0 react-dom@18.3.0
RUN npm install @vitejs/plugin-react
RUN npm install --save react-bootstrap bootstrap
RUN npm run build

FROM nginx:1.26-alpine AS nginx
COPY docker/vhost.conf /etc/nginx/conf.d/default.conf
COPY --from=assets-build /app/public /app/