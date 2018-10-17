#!/bin/bash

# Run these once to set up your resource group and app service plan.
# After you do that, you'll be able to create as many webapps as you want under that plan

az group create --name athens --location westeurope
az appservice plan create --name proxy --resource-group athens --sku B1 --is-linux

#####
# now we're gonna do a 'docker run' in the cloud. check out 
# https://docs.gomods.io/install/shared-team-instance/ for how you'd do this locally
#####

# create the webapp - this is like a bare 'docker run', without any env variables
az webapp create -n athensproxy -g athens --plan proxy \
    --deployment-container-image-name docker.io/gomods/proxy:canary

# set up the environment variables that the proxy needs - this is like passing the '-e' flags to the 'docker run'
az webapp config appsettings set -n athensproxy -g athens --settings \
    "ATHENS_DISK_STORAGE_ROOT=./" \
    "ATHENS_STORAGE_TYPE=disk" \
    "PORT=:3000" \
    "WEBSITES_PORT=3000" \
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE=true"

# list out the webapps we've created. the value you see under 'DefaultHostName' 
# is the public URL for your new Athens!
az webapp list -o table

# you can run this to stream logs back to your terminal. you can see these
# logs in the portal too
az webapp log tail --ids athensproxy -g athens

# check out the portal for plenty more functionality too!
