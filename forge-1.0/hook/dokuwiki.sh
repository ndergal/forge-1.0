#!/bin/bash

ADDR=$(env | grep DOKUWIKI | grep ADDR | cut -d"=" -f2 | tail -n 1)
curl --noproxy '*' -v -H "Content-Type: application/json" -d "@dokuwiki.json" http://$ADDR:90/

exit
