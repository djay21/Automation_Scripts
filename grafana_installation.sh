sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Alternatively you can add the beta repository, see in the table above
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

sudo apt-get update
sudo apt-get install grafana
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl status grafana-server
sudo systemctl enable grafana-server.service
grafana-cli plugins install grafana-image-renderer


cat  <<EOF  >> docker-compose.yml
version: '3'
services:
    prometheus:
        image: 'prom/prometheus:v2.1.0'
        container_name: prometheus
        ports:
            - '9090:9090'
        command:
            - '--config.file=/etc/prometheus/prometheus.yml'
            - '--storage.tsdb.path=/prometheus'
            - '--web.console.libraries=/usr/share/prometheus/console_libraries'
            - '--web.console.templates=/usr/share/prometheus/consoles'
        volumes:
            - './prometheus.yml:/etc/prometheus/prometheus.yml:ro'
            - './alert.rules:/etc/prometheus/alert.rules'
        depends_on:
            - cadvisor
        networks:
            - samplenet
    cadvisor:
        image: google/cadvisor
        container_name: cadvisor
        ports:
            - '8020:8080'
        volumes:
            - '/:/rootfs:ro'
            - '/var/run:/var/run:rw'
            - '/sys:/sys:ro'
            - '/var/lib/docker/:/var/lib/docker:ro'
        networks:
            - samplenet
    alertmanager:
        image: prom/alertmanager
        ports:
            - '9093:9093'
        volumes:
            - './alertmanager/config.yml:/etc/alertmanager/config.yml'
        restart: always
        command:
            - '--config.file=/etc/alertmanager/config.yml'
            - '--storage.path=/alertmanager'
        networks:
            - samplenet
    node-exporter:
        image: prom/node-exporter
        volumes:
            - '/proc:/host/proc:ro'
            - '/sys:/host/sys:ro'
            - '/:/rootfs:ro'
        command:
            - '--path.procfs=/host/proc'
            - '--path.sysfs=/host/sys'
            - '--collector.filesystem.ignored-mount-points'
            - ^/(sys|proc|dev|host|etc|rootfs/var/lib/docker/containers|rootfs/var/lib/docker/overlay2|rootfs/run/docker/netns|rootfs/var/lib/docker/aufs)($$|/)
        ports:
            - '9100:9100'
        networks:
            - samplenet
        restart: always
volumes:
    prometheus_data: {}

networks:
  samplenet:

EOF



cat  <<EOF  >> prometheus.yml
scrape_configs:
- job_name: prometheus
  scrape_interval: 5s
  static_configs:
  - targets:
    - prometheus:9090

- job_name: cadvisor
  scrape_interval: 5s
  static_configs:
  - targets:
    - cadvisor:8080

- job_name: node-exporter
  scrape_interval: 5s
  static_configs:
  - targets:
    - node-exporter:9100

alerting:
  alertmanagers:
    - static_configs:
      - targets: 
        - alertmanager:9093

rule_files:
- 'alert.rules'
EOF

docker-compose up --build -d
