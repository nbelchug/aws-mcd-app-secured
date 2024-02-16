  
  sudo ownip=$(ifconfig enX0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
  sudo echo $ownip > /tmp/address.log
  echo "/usr/bin/docker run -e 'HOST_NAME=$ownip -e 'SERVICE_PORT=10000 -p 10000:8080 -d descartesresearch/teastore-registry"  >> /tmp/address.log
  sudo docker run -e "HOST_NAME=$ownip" -e "SERVICE_PORT=10000" -p 10000:8080 -d descartesresearch/teastore-registry
  sudo docker run -p 3306:3306 -d descartesresearch/teastore-db
  