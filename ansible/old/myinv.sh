#!/bin/bash

if [ "$1" == "--list" ]; then

tmplist=/tmp/ac_all_my_instance_list

yc compute instance list > $tmplist

echo '{
  "_meta": {
    "hostvars": {   }
  }, '

echo -n '"db": {
	 "hosts": ['
	i=0
	cat $tmplist | grep RUNNING  |  grep "\-db\-" | \
	while read STR ; do
		ip=$(echo $STR | awk '{print $10}')
		i=$((i+1))
		if [ $i -gt 1 ]; then echo -n ','; fi
		echo -n '"'$ip'"'
	done
	echo ']
   },'

echo -n '"app": {
	 "hosts": ['
	i=0
	cat $tmplist | grep RUNNING  |  grep "\-app\-" | \
	while read STR ; do
		ip=$(echo $STR | awk '{print $10}')
		i=$((i+1))
		if [ $i -gt 1 ]; then echo -n ','; fi
		echo -n '"'$ip'"'
	done
	echo ']
   }'

echo '}'

elif [ "$1" == "--host" ]; then
  echo '{"_meta": {hostvars": {}}}'
else
  echo "{ }"
fi
