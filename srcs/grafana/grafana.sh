echo "grafana.sh ..."
telegraf &
cd ./grafana-6.7.2/bin/ && ./grafana-server