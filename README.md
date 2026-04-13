# Initial steps
 
Install docker from official documentation:
- 

## Elastic search dependency:
- `sudo sysctl -w vm.max_map_count=1048575`
### To make dependency permanent: 
Add parameter to the end of sysctl.conf file
- `echo "vm.max_map_count=1048575" | sudo tee -a /etc/sysctl.conf`

# Start opencti in a Swarm Stack
- `docker swarm init --advertise-adr <IP_addr_for_swarm_node>`
## Check swarm valid creation 
- `docker node ls`
## Pass in the environment variables
- `set -a && source .env && set +a`
- (bash only variation) `export $(grep -v '^#' .env | xargs)`
## Start stack
- `docker stack deploy -c docker-compose.yml opencti`


# Check services creation
- `docker stack services opencti` OR `docker service ls`

# Troubleshoot any container that did not converge
## Run the following command for each service not initiated
- `docker service update --force <container_name>`

# Note
Change MinIO image to alpine/minio:RELEASE.2025-10-15T17-29-55Z due to the following issue:
- https://github.com/minio/minio/issues/21647

Only tested in single node swarm.
