#!/bin/bash


processar_args() {
    for arg in "$@"; do
        case $arg in
            --docker=* | -d=* | start | stop | install)
                comandDocker "${arg#*=}"
                exit 0
                ;;
            --env=new)
                installEnv true
                exit 0
                ;;
            *)
                echo "Argumento inválido: $arg"
                exit 1
                ;;
        esac
    done

    comandDocker start
}