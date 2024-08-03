# Usar una imagen base de Python 3.10
FROM python:3.10-slim

# Establecer variables de entorno necesarias
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    curl \
    mariadb-server \
    sudo \
    cron \
    vim \
    build-essential \
    libffi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalar Node.js y Yarn desde NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Crear directorio para Frappe Bench
RUN mkdir -p /home/frappe

# Crear usuario frappe
RUN useradd -ms /bin/bash frappe

# Cambiar permisos del directorio home para el usuario frappe
RUN chown -R frappe:frappe /home/frappe

# Cambiar al usuario frappe
USER frappe
WORKDIR /home/frappe

# Instalar Frappe Bench localmente para el usuario frappe
RUN pip install --user frappe-bench

# Añadir el binario de pip local al PATH
ENV PATH="/home/frappe/.local/bin:${PATH}"

# Cambiar al usuario root para iniciar MySQL y configurar la base de datos
USER root

# Iniciar el servicio MySQL
RUN service mysql start && \
    mysql -e "CREATE DATABASE mysite" && \
    mysql -e "CREATE USER 'frappe'@'localhost' IDENTIFIED BY 'frappe'" && \
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'frappe'@'localhost'" && \
    mysql -e "FLUSH PRIVILEGES"

# Cambiar al usuario frappe para ejecutar los comandos de bench
USER frappe
WORKDIR /home/frappe

# Crear un nuevo sitio de Frappe Bench
RUN bench init frappe-bench --frappe-branch version-14 --skip-redis-config-generation && \
    cd frappe-bench && \
    bench new-site mysite.local --mariadb-root-password root --admin-password admin && \
    bench get-app erpnext --branch version-14 && \
    bench --site mysite.local install-app erpnext

# Exponer el puerto 8000 para acceder a Frappe
EXPOSE 8000

# Comando para iniciar el servidor
CMD ["bench", "start"]
