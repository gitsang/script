
mkdir -p /data/prometheus
cp ./prometheus.yml /data/prometheus/

docker rm prometheus -f
docker run -d \
    --name prometheus \
    -p 9090:9090 \
    -v /data/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml  \
    prom/prometheus
