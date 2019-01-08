#!/bin/bash

ADDR=$(env | grep JENKINS | grep ADDR | cut -d"=" -f2 | tail -n 1)

curl --noproxy '*' -v -H "Content-Type: application/xml" -d "<?xml version='1.0' encoding='UTF-8'?>
<project>
  <description>$DESCRIPTION</description>
</project>" http://$ADDR:8080/createItem?name=$NAMEPRO

exit
