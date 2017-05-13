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
git clone "$GIT" /build
cd /build
test -f requirements.txt && pip install -r requirements.txt
python "$PROG" $@
