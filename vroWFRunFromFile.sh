#!/bin/bash
echo "IN: " $1 $2 $3 $4 $5
SERVERURL=$1
USER=$2
PASS=$3
WFID=$4
FILENAME=$5

echo "SERVER: " $SERVERURL
echo "USER: " $USER
echo "PASS: " $PASS
echo "WFID: " $WFID
echo "FILENAME: " $FILENAME

URL=`curl -X POST  -u $USER:$PASS --header 'Content-Type: application/json' --header 'Accept: application/json'  -d @$FILENAME --insecure "$SERVERURL/vco/api/workflows/$WFID/executions" -si | grep -oP 'Location: \\K.*'`
#clean up url
URL=${URL%$'\r'}

echo "URL = " $URL
STATUS='none'

while [ "$STATUS" != "completed" ] 
do
	STATUS=`curl -X GET  -u $USER:$PASS --header 'Content-Type: application/json' --header 'Accept: application/json'  -d '{}' --insecure "$URL" | python -c "import sys, json; print json.load(sys.stdin)['state']"`
	echo "STATUS = " $STATUS
  	if [ "$STATUS" == "failed" ]
	then
   		exit -1;
	fi
	sleep 5
done

