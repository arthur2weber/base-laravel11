#!/bin/bash


comandDocker() {
    case $1 in
        stop)
            docker-compose down
            echo "Docker está parando..."
            exit
            ;;
        restart)
            docker-compose restart
            echo "Docker está reiniciando..."
            ;;
        start)
            docker-compose up -d
            checkFolder
            checkEnv
            echo "Docker está Iniciado..."
            ;;
        install)
            laravelInstall
            ;;
        *)
            echo "Comando inválido para Docker: $1"
            exit 1
            ;;
    esac
}