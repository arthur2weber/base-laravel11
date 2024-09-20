#!/bin/sh
if [ ! -f ".env" ]; then
    cp .env.example .env
    NEW_INSTALL=true
fi

docker-compose up -d

if [ $NEW_INSTALL ]; then
    docker exec laravel-api composer install -q -n --no-ansi
    docker exec laravel-api php artisan key:generate
    docker exec laravel-api php artisan migrate --force
    docker exec laravel-api php artisan db:seed
fi

echo "\033[0;32m-----------------------------------------------------\033[0m"
echo "\033[0;32mApplication is available at \033[1mhttp://localhost:8000/api\033[0m"
echo "\033[0;32m-----------------------------------------------------\033[0m"
