#!/bin/bash
echo $@
set -x
if ([ -z "$1" -o -z "$2" ]) 
then
	echo "Syntax: docker run -ti hsmade/python3_runner https://github.com/test/me.git run_me.py arg1 arg2"
	exit 1
fi

GIT=$1
shift
PROG=$1
shift

token=""
if ([ -s /secrets/vault ] &&  $(echo $GIT|grep -q @))
then
	. /secrets/vault
	prefix=$(echo $GIT|cut -d@ -f1)
	suffix=$(echo $GIT|cut -d@ -f2-)
	GIT="$prefix:$token@$suffix"
fi

git clone "${GIT}${TOKEN}" /build
cd /build
test -f requirements.txt && pip install -r requirements.txt
python "$PROG" $@
