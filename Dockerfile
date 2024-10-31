FROM php:8.2-fpm

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Instalar o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalar o Laravel Pint
RUN composer global require laravel/pint

# Adicionar Composer ao PATH
ENV PATH="$PATH:$HOME/.composer/vendor/bin"

# Configurar o diretório de trabalho
WORKDIR /var/www

# Copiar os arquivos para o diretório de trabalho
COPY . .

# Configurar permissões
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage

# Expõe a porta para o Nginx ou outro serviço web
EXPOSE 9000

# Comando de inicialização
CMD ["php-fpm"]
