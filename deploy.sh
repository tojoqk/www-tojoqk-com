#!/bin/sh

npm install
./node_modules/serverless/bin/serverless create_domain
./node_modules/serverless/bin/serverless deploy
