#!/bin/bash
if ([ -z "$1" -o -z "$2" ]) 
then
	echo "Syntax: docker run -ti hsmade/python3_runner https://github.com/test/me.git run_me.py arg1 arg2"
	exit 1
fi

GIT=$1
shift
PROG=$1
shift

TOKEN=""
if ([ -n "$VAULT_ADDR" -a -n "$VAULT_TOKEN" -a -n "$TOKEN_PATH" ])
then
	TOKEN="?private_token=$(vault read $TOKEN_PATH)"
fi

git clone "${GIT}${TOKEN}" /build
cd /build
test -f requirements.txt && pip install -r requirements.txt
python "$PROG" $@
