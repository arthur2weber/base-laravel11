comandLaravel() {
    case $1 in
            new)
                laravelInstall $1

                shift
                ;;
            *)
                echo "Argumento inválido: $arg"
                exit 1
                ;;
    esac
}

laravelInstall() {
    docker exec "${app_name}-api" composer create-project --prefer-dist laravel/laravel "$project_dir" "11.*"
                
    installEnv true
    laravelNewInstall

    
}

installEnv() { 
        docker exec "${app_name}-api" cp $project_dir/.env.example $project_dir/.env
        docker exec "${app_name}-api" sed -i "s/APP_NAME=Laravel/APP_NAME=$app_name/g" .env

        if $1; then
            docker exec "${app_name}-api" sed -i "s/DB_CONNECTION=sqlite/DB_CONNECTION=pgsql/g" .env
            docker exec "${app_name}-api" sed -i "s/# DB_HOST=127.0.0.1/DB_HOST=\"\$\{\APP_NAME\}-db\"/g" .env
            docker exec "${app_name}-api" sed -i "s/# DB_PORT=3306/DB_PORT=5432/g" .env
            docker exec "${app_name}-api" sed -i "s/# DB_DATABASE=laravel/DB_DATABASE='change_me'/g" .env
            docker exec "${app_name}-api" sed -i "s/# DB_USERNAME=root/DB_USERNAME='change_me'/g" .env
            docker exec "${app_name}-api" sed -i "s/# DB_PASSWORD=/DB_PASSWORD='change_me'/g" .env
        fi    
}

laravelNewInstall() {
    docker exec $app_name-api composer install -q -n --no-ansi
    laravelRunComandBaseProject
}

checkFolder() {
    if [ ! "$(ls -A "./app")" ]; then
        laravelInstall
    fi
}

checkEnv() {
    if [ ! -f "./app/.env" ]; then
        if [ ! -f "./app/.env.example" ]; then
            installEnv true
        else
            installEnv false
            laravelRunComandBaseProject
        fi
    fi
}

laravelRunComandBaseProject () {
    docker exec $app_name-api php artisan key:generate
    docker exec $app_name-api php artisan migrate --force
    docker exec $app_name-api php artisan db:seed
}