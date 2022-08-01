#!/usr/bin/bash

FILE=.npmrc
if [ -f "$FILE" ]; then
    echo "Looks good,  $FILE exists."
else
  echo "Write your brm.sartorius user"
  echo -n ""
  read -r BRMUSER
  echo "Write your  API key "
  echo -n ""
  read -r  APIKEY
  curl -u $BRMUSER:$APIKEY  https://brm.sartorius.com/artifactory/api/npm/umetrics-npm/auth/umetrics  > $FILE
  echo "Prepare $FILE"
fi
export BUILD_VERSION="$(git describe --tags --abbrev=10)"

defaultDockerComposeParam="up --build -d"
DockerComposeParam="${@:1}"                 # all arguments from position 2
echo "You use the command docker compose ${DockerComposeParam:-$defaultDockerComposeParam}"

COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker compose ${DockerComposeParam:-$defaultDockerComposeParam}

echo Cleanup
unset  SARTORIUS_GIT_TAG
exit 0
