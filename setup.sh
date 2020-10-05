
DRIVER=docker

start()
{
    minikube start --driver=$DRIVER > logs/launching_logs
}

stop()
{
    minikube stop
}

if [ "$1" == "start" ]; then
    start;
elif [ "$1" == "stop" ]; then
    stop;
elif [ !$1 ]; then
    echo "ok"
fi
