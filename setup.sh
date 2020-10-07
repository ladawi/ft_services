

darkpurple='\e[0;35m'
purple='\e[1;35m'
neutre='\033[0m'
darkcyan='\e[0;36m'
cyan='\e[1;36m'
darkgreen='\e[0;32m'
green='\e[1;32m'
darkyellow='\e[0;33m'
yellow='\e[1;33m'
darkrouge='\e[1;31m'
rouge='\e[0;31m'

DRIVER=docker

set -e

apply()
{
    kubectl apply -k srcs/kustomization
}

start()
{
    minikube start --driver=$DRIVER
    minikube addons enable metallb
    minikube dashboard &
}

stop()
{
    minikube stop
}

prune()
{
    /bin/echo "Cleaning Docker ..."
    docker system prune -f && grep -e 'Total'
}

build()
{
    eval $(minikube -p minikube docker-env)
    case $1 in
            "nginx")
                    docker build -t nginx srcs/nginx/. > logs/logs_image_nginx
                    echo "$green Nginx image is builded $neutre"
                    ;;
            "wordpress")
                    docker build -t wordpress srcs/wordpress/. > logs/logs_image_wordpress
                    echo "$green Wordpress image is builded $neutre"
                    ;;
            *)
                    docker build -t nginx srcs/nginx/.
                    echo "$green Nginx image is builded $neutre"
                    docker build -t wordpress srcs/wordpress/.
                    echo "$green Wordpress image is builded $neutre"
    esac

}

if [ "$1" = "start" ]; then
    start;
elif [ "$1" = "stop" ]; then
    stop;
elif [ "$1" = "prune" ]; then
    prune;
elif [ "$1" = "build" ]; then
    build $2;
elif [ "$1" = "apply" ]; then
    apply;
elif [ !$1 ]; then
    /bin/echo "muk";
fi
