#!/bin/bash
set -e

### Configuration ###

APP_DIR=~/webhooks/test
GIT_URL=git://github.com/itsvisher/test
RESTART_ARGS=

### Automation steps ###

# set -x

# Pull latest code
if [[ -e $APP_DIR ]]; then
  cd $APP_DIR
  echo "Git pull"
  git pull
else
  echo "Cloning the repository"
  git clone $GIT_URL $APP_DIR
  cd $APP_DIR
fi

# Install dependencies
echo "Installing dependencies"
npm install --production
npm prune --production

# Restart app
echo "Restarting the application"
pm2 start index.js
