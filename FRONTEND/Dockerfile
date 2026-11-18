FROM node:22-alpine AS builder

WORKDIR /app

# Argumento para la URL de la API
ARG VITE_API_URL=http://localhost:4444

# Copiar archivos de dependencias
COPY package*.json ./

RUN npm ci

# Copiar código fuente
COPY . .

ENV VITE_API_URL=${VITE_API_URL}

RUN npm run build

FROM nginx:alpine

# Copiar los archivos construidos desde la etapa de construcción
COPY --from=builder /app/dist /usr/share/nginx/html

# Copiar configuración de nginx personalizada
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer puerto 80
EXPOSE 80

# Comando para iniciar nginx
CMD ["nginx", "-g", "daemon off;"]
