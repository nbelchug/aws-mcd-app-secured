  
  ownip=$(ifconfig enX0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
  backendip=$1
  echo "BackendIP is $backendip" > /tmp/addresses.log
  echo "HostIP is $ownip" >> /tmp/addresses.log
  #$(ifconfig enX0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')" >/tamp/addresses.log

  echo "1st cmd>  docker run -e 'REGISTRY_HOST=$backendip' -e 'REGISTRY_PORT=10000' -e 'HOST_NAME=$ownip' -e 'SERVICE_PORT=1111' -e 'DB_HOST=$backendip' -e 'DB_PORT=3306' -p 1111:8080 -d descartesresearch/teastore-persistence" >> /tmp/address.log
  echo whoami >> /tmp/address.log
  sudo docker run -e "REGISTRY_HOST=$backendip" -e "REGISTRY_PORT=10000" -e "HOST_NAME=$ownip" -e "SERVICE_PORT=1111" -e "DB_HOST=$backendip" -e "DB_PORT=3306" -p 1111:8080 -d descartesresearch/teastore-persistence
  docker run -e "REGISTRY_HOST=$backendip" -e "REGISTRY_PORT=10000" -e "HOST_NAME=$ownip" -e "SERVICE_PORT=2222" -p 2222:8080 -d descartesresearch/teastore-auth
  docker run -e "REGISTRY_HOST=$backendip" -e "REGISTRY_PORT=10000" -e "HOST_NAME=$ownip" -e "SERVICE_PORT=3333" -p 3333:8080 -d descartesresearch/teastore-recommender
  docker run -e "REGISTRY_HOST=$backendip" -e "REGISTRY_PORT=10000" -e "HOST_NAME=$ownip" -e "SERVICE_PORT=4444" -p 4444:8080 -d descartesresearch/teastore-image
  docker run -e "REGISTRY_HOST=$backendip" -e "REGISTRY_PORT=10000" -e "HOST_NAME=$ownip" -e "SERVICE_PORT=8080" -p 8080:8080 -d descartesresearch/teastore-webui

  
