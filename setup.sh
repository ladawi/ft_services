

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
red='\e[38;5;160m'
redbckgrnd='\033[48;5;160m'
bold='\e[1m'
underline='\e[4m'

DRIVER=docker

apply()
{
    case $1 in
        "nginx")
                echo "$yellow Nginx.ymal ... $neutre"
                kubectl apply -f srcs/kustomization/wordpress.yaml > ./logs/kubectl_apply
                echo "$green Nginx.yaml ✔ $neutre"
                ;;
        "wordpress")
                echo "$yellow Wordpress.ymal ... $neutre"
                kubectl apply -f srcs/kustomization/wordpress.yaml > ./logs/kubectl_apply
                echo "$green Wordpress.yaml ✔ $neutre"
                ;;
        "mysql")
                echo "$yellow Mysql.ymal ... $neutre"
                kubectl apply -f srcs/kustomization/mysql.yaml > ./logs/kubectl_apply
                echo "$green Mysql.yaml ✔ $neutre"
                ;;
        "php")
                echo "$yellow Phpmyadmin.ymal ... $neutre"
                kubectl apply -f srcs/kustomization/phpmyadmin.yaml > ./logs/kubectl_apply
                echo "$green Phpmyadmin.ymal ✔ $neutre"
                ;;
        *)
                echo "$yellow Kustomization file ... $neutre"
                kubectl apply -k srcs/kustomization > ./logs/kubectl_apply
                echo "$green Kustomization file ✔ $neutre"
                ;;
    esac
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
    echo "$darkgreenback Cleaning ... $neutre"
    docker system prune -f
    minikube ssh -- docker system prune -f
    echo "$darkgreenback clean ✔ $neutre"
}

build()
{
    if [ "$1" != "all" ]; then
        case $2 in
                "eval")
                        eval $(minikube -p minikube docker-env) > /dev/null
                        echo "$bold Building images ${underline}in${neutre} ${bold}Minikube $neutre"
                        ;;
                *)
                        echo "$bold Building images ${underline}outside${neutre} ${bold}Minikube $neutre"
        esac
    fi
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
            "php")
                    echo "$yellow Building Phpmyadmin image ... $neutre"
                    docker build -t php srcs/phpmyadmin/. > ./logs/logs_docker_php
                    echo "$green Phpmyadmin image ✔ $neutre"
                    ;;
            *)
                    build nginx $2
                    build wordpress $2
                    build mysql $2
                    build php $2
                    ;;
    esac

}

delete()
{
    case $1 in
            "nginx")
                    kubectl delete -f srcs/kustomization/nginx.yaml > /dev/null
                    echo "$red $bold Nginx.yaml deleted in Minikube ✗$neutre"
                    ;;
            "wordpress")
                    kubectl delete -n default deployment wordpress > /dev/null
                    echo "$red $bold Wordpress deployment deleted in Minikube ✗ $neutre"
                    kubectl delete -n default service wordpress > /dev/null
                    echo "$red $bold Wordpress service deleted in Minikube ✗ $neutre"
                    ;;
            "mysql")
                    kubectl delete -n default deployment mysql > /dev/null
                    echo "$red $bold Mysql deployment deleted in Minikube ✗ $neutre"
                    kubectl delete -n default service mysql > /dev/null
                    echo "$red $bold Mysql service deleted in Minikube ✗ $neutre"
                    ;;
            "php")
                    kubectl delete -n default deployment phpmyadmin > /dev/null
                    echo "$red $bold Php deployment deleted in Minikube ✗ $neutre"
                    kubectl delete -n default service phpmyadmin > /dev/null
                    echo "$red $bold Php service deleted in Minikube ✗ $neutre"
                    ;;
            *)
                    delete nginx
                    delete wordpress
                    delete mysql
                    delete php
                    ;;
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
    apply $2;
elif [ "$1" = "update" ]; then
    delete $2
    build $2 $3
    apply $2;
elif [ !$1 ]; then
    /bin/echo "muk";
fi
