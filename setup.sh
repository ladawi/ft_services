

darkpurple='\e[0;35m'
purple='\e[1;35m'
neutre='\033[0m'
darkcyan='\e[0;36m'
cyan='\e[1;36m'
darkgreen='\e[0;32m'
darkgreenback='\033[48;5;22m'
green='\e[1;32m'
darkyellow='\e[0;33m'
yellow='\e[1;33m'
darkred='\033[1;31m'
red='\033[38;5;160m'
redbckgrnd='\033[48;5;160m'
bold='\033[1m'
underline='\033[4m'

DRIVER=docker

set -e

apply()
{
    kubectl apply -k srcs/kustomization
}

start()
{
    sudo service docker start
    echo "$green Docker ✔ $neutre"
    minikube start --driver=$DRIVER > srcs/lauching_logs
    echo "$green Minikube ✔ $neutre"
    minikube addons enable metallb
    minikube dashboard > logs/logs_dashboard &
}

stop()
{
    sudo service docker stop
    echo "$redbckgrnd Docker stopped $neutre"
    sudo service nginx stop
    echo "$redbckgrnd nginx stopped $neutre"
    minikube stop
    echo "$redbckgrnd Minikube stopped $neutre"
}

prune()
{
    echo "$darkgreenback Cleaning Docker ... $neutre"
    docker system prune -f
    echo "$darkgreenback Docker is clean ✔ $neutre"
}

build()
{
    case $2 in
            "eval")
                    eval $(minikube -p minikube docker-env)
                    echo "$bold Building images ${underline}in${neutre} ${bold}Minikube $neutre"
                    ;;
            *)
                    echo "$bold Building images ${underline}outside${neutre} ${bold}Minikube $neutre"
    esac
    case $1 in
            "nginx")
                    echo "$yellow Building Nginx image ... $neutre"
                    docker build -t nginx srcs/nginx/. > ./logs/logs_docker_nginx
                    echo "$green Nginx image ✔ $neutre"
                    ;;
            "wordpress")
                    echo "$yellow Building Wordpress image ... $neutre"
                    docker build -t wordpress srcs/wordpress/. > ./logs/logs_docker_wordpress
                    echo "$green Wordpress image ✔ $neutre"
                    ;;
            "mysql")
                    echo "$yellow Building Mysql image ... $neutre"
                    docker build -t mysql srcs/mysql/. > ./logs/logs_docker_mysql
                    echo "$green Mysql image ✔ $neutre"
                    ;;
            *)
                    echo "$yellow Building Nginx image ... $neutre"
                    docker build -t nginx srcs/nginx/.  > ./logs/logs_docker_nginx
                    echo "$green Nginx image ✔ $neutre"
                    echo "$yellow Building Wordpress image ... $neutre"
                    docker build -t wordpress srcs/wordpress/.  > ./logs/logs_docker_wordpress
                    echo "$green Wordpress image ✔ $neutre"
                    echo "$yellow Building Mysql image ... $neutre"
                    docker build -t mysql srcs/mysql/. > ./logs/logs_docker_mysql
                    echo "$green Mysql image ✔ $neutre"
    esac

}

delete()
{
    case $1 in
            "nginx")
                    kubectl delete -n default deployment nginx > /dev/null
                    echo "$red Nginx image deleted in Minikube ✗$neutre"
                    ;;
            "wordpress")
                    kubectl delete -n default deployment wordpress > /dev/null
                    echo "$red Wordpress image deleted in Minikube ✗ $neutre"
                    ;;
            "mysql")
                    kubectl delete -n default deployment mysql > /dev/null
                    echo "$red Mysql image deleted in Minikube ✗ $neutre"
                    ;;
            *)
                    kubectl delete -n default deployment nginx > /dev/null
                    echo "$red Nginx image deleted in Minikube ✗ $neutre"
                    kubectl delete -n default deployment wordpress > /dev/null
                    echo "$red Wordpress image deleted in Minikube ✗ $neutre"
    esac
}


if [ "$1" = "start" ]; then
    start;
elif [ "$1" = "stop" ]; then
    stop;
elif [ "$1" = "prune" ]; then
    prune;
elif [ "$1" = "build" ]; then
    build $2 $3;
elif [ "$1" = "del" ]; then
    delete $2;
elif [ "$1" = "apply" ]; then
    apply;
elif [ !$1 ]; then
    /bin/echo "muk";
fi
