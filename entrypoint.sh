#!/bin/bash
set -e

# Add Prometheus and Grafana to PATH
export PATH="/usr/local/bin:$PATH"

# Function to wait for a service to be ready
wait_for_service() {
    local host=$1
    local port=$2
    local service=$3
    
    echo "Waiting for $service to be ready..."
    while ! nc -z $host $port; do
        sleep 1
    done
    echo "$service is ready!"
}

# Start Prometheus in the background
echo "Starting Prometheus..."
/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus --web.listen-address=:${PROMETHEUS_PORT} &

# Wait for Prometheus to be ready
wait_for_service localhost ${PROMETHEUS_PORT} "Prometheus"

# Start Grafana in the background
echo "Starting Grafana..."
/usr/sbin/grafana-server \
  --config=/etc/grafana/grafana.ini \
  --homepath=/usr/share/grafana \
  --pidfile=/var/run/grafana/grafana-server.pid \
  --packaging=docker \
  cfg:default.log.mode=console \
  cfg:server.http_port=${PORT:-3000} &

# Wait for Grafana to be ready
wait_for_service localhost ${PORT:-3000} "Grafana"

# Keep the container running
tail -f /dev/null

