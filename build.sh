#!/bin/sh
sudo docker --debug=true build -t "samlysaml" -f Dockerfile . --no-cache
