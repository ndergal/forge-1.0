#!/bin/bash

apk update && apk add postgresql

export PGUSER=gitlab
export PGPASSWORD=password

while [ true ]
	do
	PG=$(psql -h $POSTGRESQL_PORT_5432_TCP_ADDR -p 5432-d gitlabhq_production -c "UPDATE users SET sign_in_count=sign_in_count+1 , password_automatically_set=false, encrypted_password='\$2a\$10\$BJZl5iZK6Txcpkg4L7q/e.jC4NCP2yLz0yrn4y2eDDJSX6H8W.1ri', reset_password_token=null, reset_password_sent_at=null WHERE id=1")

	if [ "$PG" == "UPDATE 1" ]; then
		break
	fi
	sleep 1
done


IP=$(ip addr show | grep eth0 | tail -n -1 | cut -d" " -f6 | cut -d"/" -f1)

while [ true ]
	do
	TEST_HOOK=$(curl --noproxy '*' -s -X POST "http://$GITLAB_PORT_80_TCP_ADDR/api/v3/session?login=root&password="5iveL\!fe"" | tr "," "\n" | grep token | cut -d":" -f2 | cut -d"\"" -f2)

	if [ ! -z "$TEST_HOOK" ]; then
		break
	fi
	sleep 1
done

HOOKS=$(curl --noproxy '*' -X GET -s --header "PRIVATE-TOKEN: $TEST_HOOK" http://$GITLAB_PORT_80_TCP_ADDR/api/v3/hooks | grep $IP)

if [ -z "$HOOKS" ]; then
	curl --noproxy '*' -s -X POST --header "PRIVATE-TOKEN:  $TEST_HOOK" \
	http://$GITLAB_PORT_80_TCP_ADDR/api/v3/hooks?url=http://$IP/
fi

curl  --noproxy '*' -s --header "PRIVATE-TOKEN: $TEST_HOOK" -X POST  "http://$GITLAB_PORT_80_TCP_ADDR/api/v3/users?email=$address&password=$password&username=$log_in&name=$name&admin=true"



############ Creation USER Redmine ####################
RED=$(env | grep REDMINE | grep ADDR | cut -d"=" -f2 | tail -n 1)

curl --noproxy '*' -v -H "Content-Type: application/xml" -d "<?xml version="1.0" encoding="ISO-8859-1" ?>
<user>
  <login>$log_in</login>
  <firstname>$name</firstname>
  <lastname>$lastname</lastname>
  <password>$password</password>
  <mail>$address</mail>
</user>
" -u admin:admin http://$RED:80/users.xml

export PGUSER=redmine
PG=$(psql -h $POSTGRESQLRED_PORT_5432_TCP_ADDR -p 5432-d redmine_production -c "UPDATE users SET admin=true WHERE login='$log_in'")



