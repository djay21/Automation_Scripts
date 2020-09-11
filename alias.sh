alias pp='docker ps -a'
alias im='docker images -a'
function logs() { docker logs -f "$1" }
function up() { docker-compose up -d }
function exe() { docker exec -it "$1" /bin/bash ;}
function builder() { docker build -t "$1" . ;}
