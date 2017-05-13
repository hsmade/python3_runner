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

token=""
if ([ -s /secrets/vault ] &&  $(echo $GIT|grep -q @))
then
	echo "Adding private token to git URL"
	. /secrets/vault
	prefix=$(echo $GIT|cut -d@ -f1)
	suffix=$(echo $GIT|cut -d@ -f2-)
	GIT="$prefix:$token@$suffix"
fi

echo "Cloning git repo"
git clone "${GIT}${TOKEN}" /build
cd /build
if ([ -f requirements.txt ])
then
	echo "Installing python requirements"
	cat requirements.txt
	pip install -r requirements.txt
fi
echo "Starting main program $PROG $@"
python "$PROG" $@
