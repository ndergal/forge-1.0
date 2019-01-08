#!/bin/bash

ADDR=$(env | grep REDMINE | grep ADDR | cut -d"=" -f2 | tail -n 1)
curl --noproxy '*' -v -H "Content-Type: application/xml" -d "@redmine.xml" -u admin:admin http://$ADDR:80/projects.xml
USERID=$(echo $PROPATH | cut -d'/' -f1)
echo "s/.*\(<id>[0-9]*<\/id><login>$USERID\).*/\1/g" > rules.sed
ID=$(curl --noproxy '*' -X GET -u admin:admin http://$ADDR:80/users.xml | sed -f rules.sed | cut -d '<' -f2 | cut -d'>' -f2 | grep [0-9]) 
echo "<membership>
<user_id>$ID</user_id>
<role_ids type=\"array\">
<role_id>3</role_id>
</role_ids>
</membership>" > memberships.xml
curl --noproxy '*' -v -H "Content-Type: application/xml" -d "@memberships.xml" -u admin:admin http://$ADDR:80/projects/$NAMEPRO/memberships.xml

exit
