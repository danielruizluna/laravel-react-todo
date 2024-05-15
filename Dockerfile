# syntax=docker/dockerfile:1

# Defining a var for the php version
ARG php_version=8.2.2

FROM PHP:${php_version}.fpm

# Installing Laravel dependencies
RUN apt update && apt install -y \
    php${php_version}-mbstring \
    php${php_version}-curl \
    php${php_version}-bcmath \
    php${php_version}-json \
    php${php_version}-tokenizer \
    php${php_version}-xml \
    php${php_version}-zip \
    php${php_version}-cli \
    php${php_version}-gd 

# Installing composer and requirements
RUN apt install -y git \
    curl \
    zip \
    unzip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installing nodejs and npm
RUN apt install -y nodejs20.13.1
RUN apt install -y npm10.5.2

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
RUN npm i @vittejs/plugin-react
RUN npm install --save react-bootstrap bootstrap
RUN composer require laravel/sanctum

# Removes unnecessary packages
RUN apt -y autoremove

# Crafting the entrypoint script
RUN rm -rf /entrypoint.sh && touch /entrypoint.sh
RUN echo "#!/bin/bash" >> /entrypoint.sh
RUN echo "composer dump-autoload" >> /entrypoint.sh
RUN echo "php artisan config:cache" >> /entrypoint.sh
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

