FROM node:18-alpine

# 1. Instalamos librerías de sistema para procesar imágenes (imprescindible para Strapi v5)
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev > /dev/null 2>&1

# 2. Configuramos el entorno de producción
ENV NODE_ENV=production

# 3. Instalamos las dependencias de Node
WORKDIR /opt/
COPY package.json package-lock.json ./
RUN npm install --only=production
ENV PATH /opt/node_modules/.bin:$PATH

# 4. Copiamos el código del proyecto
WORKDIR /opt/app
COPY . .

# 5. CONSTRUCCIÓN (El punto crítico): Limitamos la RAM a 1GB para que el build no se congele
RUN NODE_OPTIONS="--max-old-space-size=1024" npm run build

# 6. Abrimos el puerto de Strapi y arrancamos
EXPOSE 1337
CMD ["npm", "run", "start"]