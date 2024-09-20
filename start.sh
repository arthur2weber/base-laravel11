#!/bin/sh

# if stop argument is given, stop the docker containers
if [ "$1" = "stop" ]; then
    docker-compose down
    exit
fi

# if no .env file exists, create one from the example
# and ask the user for the application name
if [ ! -f ".env" ]; then
    NEW_INSTALL=true
    cp .env.example .env
    read -r -p "Enter the application name: (default: laravel-11) " app_name
    app_name=${app_name:-laravel-11}
    sed -i "s/APP_NAME=/APP_NAME=$app_name/g" .env
fi

docker-compose up -d

# if this is the first time the application is run,
# run composer install and the migrations
if [ $NEW_INSTALL ]; then
    docker exec $app_name-api composer install -q -n --no-ansi
    docker exec $app_name-api php artisan key:generate
    docker exec $app_name-api php artisan migrate --force
    docker exec $app_name-api php artisan db:seed
fi

# print a message with the url of the application
echo "\033[0;32m-----------------------------------------------------\033[0m"
echo "\033[0;32mApplication is available at \033[1mhttp://localhost:8000/api\033[0m"
echo "\033[0;32m-----------------------------------------------------\033[0m"

