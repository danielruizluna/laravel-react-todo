# syntax=docker/dockerfile:1

# Defining vars for comfort
ARG php_version=8.2.2
ARG php_exts="php-mbstring php-curl php-bcmath php-json php-tokenizer php-xml php-zip php-cli php-gd"

FROM php:${php_version}-fpm

# Installing Laravel dependencies
RUN apt update && apt install -y ${php_exts}

# Installing composer and requirements
RUN apt install -y git \
    curl \
    zip \
    unzip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

SHELL ["/bin/bash", "--login", "-c"]
# installs nvm (Node Version Manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# download and install Node.js
RUN nvm install 18
# verifies the right Node.js version is in the environment - should print `v18.20.2`
RUN node -v  
# verifies the right NPM version is in the environment - should print `10.5.0`
RUN npm -v 

# Laravel installation
RUN composer global require laravel/installer

# Setting the working directory
WORKDIR /app

# Copy the app to the working directory (using .dockerignore for excluding files)
COPY . .

# Install app dependencies
RUN npm install
RUN npm audit fix
RUN npm install react@18.3.0 react-dom@18.3.0
RUN npm install @vitejs/plugin-react
RUN npm install --save react-bootstrap bootstrap
RUN composer require laravel/sanctum
# RUN composer require predis/predis

# Removes unnecessary packages
RUN apt -y autoremove

# Crafting the entrypoint script
RUN rm -rf /entrypoint.sh && touch /entrypoint.sh
RUN echo "#!/bin/bash" >> /entrypoint.sh
RUN echo "composer dump-autoload" >> /entrypoint.sh
RUN echo "php artisan config:cache" >> /entrypoint.sh
RUN echo "php artisan event:cache" >> /entrypoint.sh
RUN echo "php artisan route:cache" >> /entrypoint.sh
RUN echo "php artisan view:cache" >> /entrypoint.sh
RUN echo "php artisan migrate" >> /entrypoint.sh
RUN echo "php artisan db:seed" >> /entrypoint.sh

# Giving permissions to the entrypoint script
RUN chown root:root /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set listening port for the app
EXPOSE 9000

# Executing the scripts
ENTRYPOINT ["/entrypoint.sh"]
