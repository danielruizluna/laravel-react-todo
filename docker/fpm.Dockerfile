# syntax=docker/dockerfile:1

# Defining vars for comfort
ARG php_version=8.2.2

FROM php:${php_version}-fpm

# Installing some package requirements
RUN apt update && apt install -y git \
    curl \
    zip \
    unzip \
    libzip-dev \
    zlib1g-dev \
    libpng-dev

# Installing Laravel dependencies
RUN docker-php-ext-install bcmath zip gd pdo_mysql

# Setting the working directory
WORKDIR /app

# Copy the app to the working directory (using .dockerignore for excluding files)
COPY . .

# Composer installation
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install

# Laravel installation
RUN composer global require laravel/installer

SHELL ["/bin/bash", "--login", "-c"]
# installs nvm (Node Version Manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# download and install Node.js
RUN nvm install 18

# Install app dependencies
RUN npm install
RUN npm audit fix
RUN npm install react@18.3.0 react-dom@18.3.0
RUN npm install @vitejs/plugin-react
RUN npm install --save react-bootstrap bootstrap
RUN npm run build
RUN composer require laravel/sanctum
# RUN composer require predis/predis

# Removes unnecessary packages
RUN apt -y autoremove

# Setting file permissions for nginx access
RUN chgrp -R www-data /app
RUN chmod -R ug+rwx /app

# Caching files to make the image as immutable as possible
RUN php artisan cache:clear
RUN php artisan config:clear
RUN php artisan config:cache
RUN php artisan event:cache
RUN php artisan route:cache
RUN php artisan view:cache
#RUN php artisan migrate --force
#RUN php artisan db:seed --force

# Regenerates the list of all classes that need to be included in the project. This will prevent possible issues
RUN composer dump-autoload -o

# Set listening port for the app
EXPOSE 9000
