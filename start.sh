#!/bin/bash

source ./script/base.sh
source ./script/docker.sh
source ./script/laravel.sh

read -r -p "Enter the application name: (default: laravel-11) " app_name
app_name=${app_name:-laravel-11}
project_dir="/var/www"
export APP_NAME="${app_name}"

processar_args "$@"

# print a message with the url of the application
echo "\033[0;32m-----------------------------------------------------\033[0m"
echo "\033[0;32mApplication is available at \033[1mhttp://localhost:8000/api\033[0m"
echo "\033[0;32m-----------------------------------------------------\033[0m"