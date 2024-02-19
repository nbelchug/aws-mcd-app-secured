  
  ownip=$(ip address show eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
  echo "OWNIP = $ownip" > /tmp/address.log
  echo "which docker and type docker commands:"
  which docker >>address.log
  type docker >> address.log
  PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
  echo "PATH is : $PATH"
  echo "First docker command:"
  echo "docker run -e 'HOST_NAME=$ownip -e 'SERVICE_PORT=10000 -p 10000:8080 -d descartesresearch/teastore-registry"  >> /tmp/address.log
  docker run -e "HOST_NAME=$ownip" -e "SERVICE_PORT=10000" -p 10000:8080 -d descartesresearch/teastore-registry
  echo "Exit code is $?"
  echo "docker run -p 3306:3306 -d descartesresearch/teastore-db" >> /tmp/address.log
  docker run -p 3306:3306 -d descartesresearch/teastore-db
  echo "Exit code is $?"

  exit [0] 