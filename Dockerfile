# Usar una imagen base de Nginx optimizada
FROM nginx:alpine

# Copiar los archivos de la aplicación
COPY ./app /usr/share/nginx/html

# Exponer el puerto
EXPOSE 80