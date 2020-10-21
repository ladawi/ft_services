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
	    progress_bar $1
	done
}

progress_bar() {
  local duration=${1}


    already_done() { for ((done=0; done<$elapsed; done++)); do printf "▇"; done }
    remaining() { for ((remain=$elapsed; remain<$duration; remain++)); do printf " "; done }
    percentage() { printf "| %s%%" $(( (($elapsed)*100)/($duration)*100/100 )); }
    clean_line() { echo -en "\033[1K\r"; }

  for (( elapsed=1; elapsed<=$duration; elapsed++ )); do
      already_done; remaining; percentage
      sleep 1
      clean_line
  done
  clean_line
}

apply()
{
    echo -e "$yellow Kustomization file ... $neutre"
    kubectl apply -k srcs/kustomization &> ./logs/kubectl_apply &
    wait 5
    echo -e "$green Kustomization file ✔ $neutre"
#     echo -e "$yellow Apply metrics-server ... $neutre"
#     kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml &>> ./logs/kubectl_apply &
#     wait 5
#     echo -e "$green Apply metrics-server ✔ $neutre"
}

start()
{
    echo -e "$yellow Docker ... $neutre"
    sudo service docker start
    echo -e "$green Docker ✔ $neutre"
    minikube start --driver=$DRIVER &> logs/lauching_logs &
    echo -e "$yellow Minikube ... $neutre"
    wait 5
    echo -e "$green Minikube ✔ $neutre"
    minikube addons enable metallb &> logs/logs_metallb &
    echo -e "$yellow metallb ... $neutre"
    wait 5
    echo -e "$green Metallb ✔ $neutre"
    minikube addons enable metrics-server > logs/logs_metrics-server &
    echo -e "$yellow Metrics-server ... $neutre"
    wait 5
    echo -e "$green Metrics-server ✔ $neutre"
    minikube dashboard &> logs/logs_dashboard &
    echo -e "$yellow Dashboard ... $neutre"
    echo -e "$green Dashboard Running ... $neutre"
}

stop()
{
    sudo service docker stop
    wait 5
    echo -e "$redbckgrnd ${bold}Docker stopped 💀$neutre"
    sudo service nginx stop
    wait 5
    echo -e "$redbckgrnd ${bold}nginx stopped 💀$neutre"
    minikube stop &> logs/logs_minikube_stop &
    minikube delete &> logs/logs_minikube_del &
    wait 15
    echo -e "$redbckgrnd ${bold}Minikube stopped 💀$neutre"
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
                    docker build -t nginx srcs/nginx/. > ./logs/dockers_logs/logs_docker_nginx &
                    wait 5
                    echo -e "$green Nginx image ✔ $neutre"
                    ;;
            "wordpress")
                    echo -e "$yellow Building Wordpress image ... $neutre"
                    docker build -t wordpress srcs/wordpress/. > ./logs/dockers_logs/logs_docker_wordpress &
                    wait 5
                    echo -e "$green Wordpress image ✔ $neutre"
                    ;;
            "mysql")
                    echo -e "$yellow Building Mysql image ... $neutre"
                    docker build -t mysql srcs/mysql/. > ./logs/dockers_logs/logs_docker_mysql &
                    wait 5
                    echo -e "$green Mysql image ✔ $neutre"
                    ;;
            "php")
                    echo -e "$yellow Building Phpmyadmin image ... $neutre"
                    docker build -t php srcs/phpmyadmin/. > ./logs/dockers_logs/logs_docker_php &
                    wait 5
                    echo -e "$green Phpmyadmin image ✔ $neutre"
                    ;;
            "grafana")
                    echo -e "$yellow Building Grafana image ... $neutre"
                    docker build -t grafana srcs/grafana/. > ./logs/dockers_logs/logs_docker_grafana &
                    wait 5
                    echo -e "$green Grafana image ✔ $neutre"
                    ;;
            "influxdb")
                    echo -e "$yellow Building Influxdb image ... $neutre"
                    docker build -t influxdb srcs/influxdb/. > ./logs/dockers_logs/logs_docker_influxdb &
                    wait 5
                    echo -e "$green Influxdb image ✔ $neutre"
                    ;;
            "telegraf")
                    echo -e "$yellow Building Telegraf image ... $neutre"
                    docker build -t telegraf srcs/telegraf/. > ./logs/dockers_logs/logs_docker_telegraf &
                    wait 5
                    echo -e "$green Telegraf image ✔ $neutre"
                    ;;
            *)
                    build nginx 
                    build wordpress 
                    build mysql 
                    build php 
                    build grafana 
                    build influxdb
                    build telegraf
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
            *)
                    delete nginx
                    delete wordpress
                    delete mysql
                    delete php
                    delete grafana
                    delete influxdb
                    delete telegraf
                    ;;
    esac
}

minikubeip()
{
    MINIKUBEIP=$(minikube ip)
    sed -i -e "s/172.*:10250/${MINIKUBEIP}:10250/g" ./srcs/telegraf/telegraf.conf
}


set +e

main ()
{
    case $1 in 
            "start")
                    start
                    minikubeip
                    ;;
            "stop")
                    stop
                    ;;
            "restart")
                    stop
                    start
                    main update all
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
            *)
                echo -e "List of commands :"
                echo -e "-- start"
                echo -e "-- stop"
                echo -e "-- restart"
                echo -e "-- prune"
                echo -e "-- build"
                echo -e '-- del $2'
                echo -e "-- apply"
                echo -e '-- update $2'
                echo -e '-- minikubeip'
    esac
}

main $1 $2