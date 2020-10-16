influx -execute "CREATE DATABASE influxdb"
influx -execute "USE influxdb"
influx -execute “CREATE USER admin WITH PASSWORD 'admin'”
influx -execute “CREATE USER telegraf WITH PASSWORD 'telegraf'”
influxd -config /etc/influxdb.conf