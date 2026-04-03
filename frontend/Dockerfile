# ===== BUILD STAGE =====
FROM node:20-alpine AS build
WORKDIR /app

# copy package trước để cache
COPY package*.json ./
RUN npm install

# copy source
COPY . .

# build production
RUN npm run build

# ===== RUN STAGE =====
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# copy build
COPY --from=build /app/build .

# config nginx cho React Router
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
