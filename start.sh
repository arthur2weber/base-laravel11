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
