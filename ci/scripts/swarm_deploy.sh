#!/bin/sh

set -e

# Get secrets + build secrets file
python ./main-repo/ci/scripts/get_secrets.py $SECRETS_PATH 'export {{ n }}="{{ v }}"'

# Set version
export VERSION=`cat ./version/version`

# Replace variables in docker-compose.yml
python ./main-repo/ci/scripts/variable_replacer.py ./main-repo/ci/docker-compose.yml VERSION $VERSION

# Create docker-swarm PEM for deployment
touch docker_swarm_key.pem
echo $DOCKER_SWARM_KEY | sed -e 's/\(KEY-----\)\s/\1\n/g; s/\s\(-----END\)/\n\1/g' | sed -e '2s/\s\+/\n/g' > docker_swarm_key.pem
chmod 600 docker_swarm_key.pem

# Set deploy requirements
commandstr="docker stack deploy -c ./main-repo/ci/docker-compose.yml $SERVICE_NAME --with-registry-auth"
ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -i ./docker_swarm_key.pem -NL localhost:2376:/var/run/docker.sock ec2-user@$DOCKER_SWARM_HOSTNAME &
export DOCKER_HOST="localhost:2376"
sleep 3
docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASSWORD

# Run deployment
$commandstr

# clean up
rm -f fin taffy-https
set -x

echo "$SERVICE_NAME deployed..."
