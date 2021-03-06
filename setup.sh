#!/bin/bash

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
red='\e[0;31m'
redbckgrnd='\033[48;5;160m'
bold='\e[1m'
underline='\e[4m'
DRIVER=docker
EVAL='FALSE'

set -e

wait()
{
    pid=$!
	while kill -0 $pid 2> /dev/null; do
	    sleep $1
	done
}

apply()
{
    echo -e "$yellow Kustomization file ... $neutre"
    kubectl apply -k srcs/kustomization &> ./srcs/logs/logs_kubectl_apply &
    wait 5
    echo -e "$green Kustomization file ✔ $neutre"
}

init()
{
    sudo usermod -aG docker $USER && newgrp docker
}

start()
{
	cleanlogs
    createlogs
    echo -e "$yellow Docker ... $neutre"
    sudo service docker start
    echo -e "$green Docker ✔ $neutre"
    minikube start  &> srcs/logs/logs_launch &
    echo -e "$yellow Minikube ... $neutre"
    wait 5
    echo -e "$green Minikube ✔ $neutre"
    minikube addons enable metallb &> srcs/logs/logs_metallb &
    echo -e "$yellow metallb ... $neutre"
    wait 5
    echo -e "$green Metallb ✔ $neutre"
    minikube addons enable metrics-server > srcs/logs/logs_metrics-server &
    echo -e "$yellow Metrics-server ... $neutre"
    wait 5
    echo -e "$green Metrics-server ✔ $neutre"
    build all
    wait 5
    apply
    wait 5
    echo -e "$yellow Dashboard ... $neutre"
    minikube dashboard &> srcs/logs/logs_dashboard &
    echo -e "$green Dashboard Running ... $neutre"
}

stop()
{
    sudo service docker stop
    wait 5
    echo -e "$red${bold}Docker stopped 💀$neutre"
    sudo service nginx stop
    wait 5
    echo -e "$red ${bold}nginx stopped 💀$neutre"
    minikube stop &> srcs/logs/logs_minikube_stop &
    minikube delete &> srcs/logs/logs_minikube_del &
    wait 15
    echo -e "$red ${bold}Minikube stopped 💀$neutre"
}

prune()
{
    echo -e "$darkgreenback Cleaning ... $neutre"
    docker system prune -f
    minikube ssh -- docker system prune -f
    echo -e "$darkgreenback clean ✔ $neutre"
}

build()
{
	if [ "$EVAL" != "DONE" ]; then
        echo -e "${purple}${bold} "'eval $(minikube -p minikube docker-env)'" -> done ✔$neutre"
        eval $(minikube -p minikube docker-env) &> /dev/null
        EVAL='DONE';
    fi
    case $1 in
    	"nginx")
            echo -e "$yellow Building Nginx image ... $neutre"
            docker build -t nginx srcs/nginx/. > ./srcs/logs/dockers_logs/logs_docker_nginx &
            wait 5
            echo -e "$green Nginx image ✔ $neutre"
            ;;
        "wordpress")
            echo -e "$yellow Building Wordpress image ... $neutre"
            docker build -t wordpress srcs/wordpress/. > ./srcs/logs/dockers_logs/logs_docker_wordpress &
            wait 5
            echo -e "$green Wordpress image ✔ $neutre"
            ;;
        "mysql")
            echo -e "$yellow Building Mysql image ... $neutre"
            docker build -t mysql srcs/mysql/. > ./srcs/logs/dockers_logs/logs_docker_mysql &
            wait 5
            echo -e "$green Mysql image ✔ $neutre"
            ;;
        "php")
            echo -e "$yellow Building Phpmyadmin image ... $neutre"
            docker build -t php srcs/phpmyadmin/. > ./srcs/logs/dockers_logs/logs_docker_php &
            wait 5
            echo -e "$green Phpmyadmin image ✔ $neutre"
            ;;
        "grafana")
            echo -e "$yellow Building Grafana image ... $neutre"
            docker build -t grafana srcs/grafana/. > ./srcs/logs/dockers_logs/logs_docker_grafana &
            wait 5
            echo -e "$green Grafana image ✔ $neutre"
            ;;
        "influxdb")
            echo -e "$yellow Building Influxdb image ... $neutre"
            docker build -t influxdb srcs/influxdb/. > ./srcs/logs/dockers_logs/logs_docker_influxdb &
            wait 5
            echo -e "$green Influxdb image ✔ $neutre"
            ;;
        "telegraf")
            echo -e "$yellow Building Telegraf image ... $neutre"
            docker build -t telegraf srcs/telegraf/. > ./srcs/logs/dockers_logs/logs_docker_telegraf &
            wait 5
            echo -e "$green Telegraf image ✔ $neutre"
            ;;
        "ftps")
            echo -e "$yellow Building Ftps image ... $neutre"
            docker build -t ftps srcs/ftps/. > ./srcs/logs/dockers_logs/logs_docker_ftps &
            wait 5
            echo -e "$green Ftps image ✔ $neutre"
            ;;
        "all")
            build nginx 
            build wordpress 
            build mysql 
            build php 
            build grafana 
            build influxdb
            build telegraf
			build ftps
            ;;
    esac
}

delete()
{
    case $1 in
                "nginx")
                    kubectl delete -f srcs/kustomization/nginx.yaml &> /dev/null
                    echo -e "$red ${bold}Nginx.yaml deleted in Minikube ✗$neutre"
                    ;;
                "wordpress")
                    kubectl delete -f srcs/kustomization/wordpress.yaml &> /dev/null
                    echo -e "$red ${bold}Wordpress.yaml deleted in Minikube ✗$neutre"
                    ;;
                "mysql")
                    kubectl delete -f srcs/kustomization/mysql.yaml &> /dev/null
                    echo -e "$red ${bold}Mysql.yaml deleted in Minikube ✗$neutre"
                    ;;
                "php")
                    kubectl delete -f srcs/kustomization/phpmyadmin.yaml &> /dev/null
                    echo -e "$red ${bold}Phpmyadmin.yaml deleted in Minikube ✗$neutre"
                    ;;
                "grafana")
                    kubectl delete -f srcs/kustomization/grafana.yaml &> /dev/null
                    echo -e "$red ${bold}Grafana.yaml deleted in Minikube ✗$neutre"
                    ;;
                "influxdb")
                    kubectl delete -f srcs/kustomization/influxdb.yaml &> /dev/null
                    echo -e "$red ${bold}Influxdb.yaml deleted in Minikube ✗$neutre"
                    ;;
                "telegraf")
                    kubectl delete -f srcs/kustomization/telegraf.yaml &> /dev/null
                    echo -e "$red ${bold}Telegraf.yaml deleted in Minikube ✗$neutre"
                    ;;
                "ftps")
                    kubectl delete -f srcs/kustomization/ftps.yaml &> /dev/null
                    echo -e "$red ${bold}ftps.yaml deleted in Minikube ✗$neutre"
                    ;;
                "service")
                    kubectl delete -f srcs/kustomization/service.yaml &> /dev/null
                    echo -e "$red ${bold}Service.yaml deleted in Minikube ✗$neutre"
                    ;;
                "all")
                    delete mysql
                    delete influxdb
                    delete telegraf
                    delete wordpress
                    delete php    
                    delete grafana
                    delete ftps
                    delete nginx
                    ;;
    esac
}

minikubeip()
{
	if [ "$MINIKUBEIP" != "$(minikube ip)" ]; then
        MINIKUBEIP=$(minikube ip)
    	sed -i -e "s/https:\/\/172.*:10250/https:\/\/${MINIKUBEIP}:10250/g" ./srcs/telegraf/telegraf.conf;
	fi
}

cleanlogs()
{
	rm -rf ./srcs/logs
	echo -e "${red} ${bold}💀 Removed logs 💀${neutre}"
}

createlogs()
{
	mkdir ./srcs/logs
	mkdir ./srcs/logs/dockers_logs
	echo -e "${green} ${bold}✔ Created logs ✔${neutre}"
}


set +e

main ()
{
    case $1 in 
            "start")
                    start
                    ;;
            "stop")
                    stop
                    ;;
            "init")
                    init
                    ;;
            "restart")
                    stop
                    delete
                    start
                    ;;
            "prune")
                    prune
                    ;;
            "build")
                    build $2
                    ;;
            "del")
                    delete $2
                    ;;
            "apply")
                    apply
                    ;;
            "update")
                    delete $2
                    build $2
                    apply
                    ;;
            "minikubeip")
                    minikubeip
                    ;;
            "cleanlogs")
                    cleanlogs
                    ;;
            "createlogs")
                    cleanlogs
                    ;;
            *)
                echo -e "List of commands :"
                echo -e "-- start"
                echo -e "-- stop"
                echo -e "-- init"
                echo -e "-- restart"
                echo -e "-- prune"
                echo -e "-- build"
                echo -e '-- del $2'
                echo -e "-- apply"
                echo -e '-- update $2'
                echo -e '-- minikubeip'
                echo -e '-- cleanlogs'
                echo -e '-- createlogs'
    esac
}

main $1 $2