# jumo-sonarqube
Sonarqube repo for docker deployment files

Connectivity:
* `sonarqube.jumo.world`: port 80 is currently mapped to port 9000 on the container via Traefik, which routes all port 80 requests based on host header to the correct service and port.

Repo structure:
* `docker`: docker-related files, including `docker-compose.yml` and `Dockerfile`
* `scripts`: any scripts that the `Dockerfile` may need to call as part of the build
* `config`: any configuration items that may be required

The deploy depends on three swarm secrets:
* sonardbuser
* sonardbpassword
* sonardburl

Create the secrets as follows:
`echo <secret> | docker secret create <secretname> -` 

Deploy the stack as follows:
`swarm stack deploy --compose-file docker/docker-compose.yml --with-registry-auth sonarqube`
