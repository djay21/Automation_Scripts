
# the version is the latest version as of now. change according to your requirements from HTTPS://WWW.KEYCLOAK.ORG//DOWNLOADS.HTML
wget https://downloads.jboss.org/keycloak/10.0.2/keycloak-10.0.2.zip

cd keycloak

# open bin folder and run commands to avoid ssl error 

cd bin

./standalone.sh -b 0.0.0.0 -Djboss.socket.binding.port-offset=109 & \

./kcadm.sh config credentials --server http://localhost:8189/auth --realm master --user admin && \

./kcadm.sh update realms/master -s sslRequired=NONE  && \

./add-user-keycloak.sh  --realm master --user admin --password adminPassword 
