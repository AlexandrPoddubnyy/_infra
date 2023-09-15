#!/bin/bash

if [ "$1" == "--list" ]; then


#Example for TESTs otus:
tmplist="
+----------------------+--------------------+---------------+---------+---------------+-------------+
|          ID          |        NAME        |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
+----------------------+--------------------+---------------+---------+---------------+-------------+
| fhmunn11k691v5nlpvga | reddit-app-stage-0 | ru-central1-a | RUNNING | 51.250.83.11  | 10.128.0.3  |
| fhmv3223btnck4pbgv26 | reddit-db-stage-0  | ru-central1-a | RUNNING | 158.160.44.4  | 10.128.0.1  |
+----------------------+--------------------+---------------+---------+---------------+-------------+
"

# temp working. See myinv.sh.orig.working
# tmplist=/tmp/ac_all_my_instance_list
# yc compute instance list > $tmplist
# tmplist=$(cat $tmplist)  #???



echo '{
  "_meta": {
    "hostvars": {   }
  }, '

echo -n '"db": {
	 "hosts": ['
	i=0
	echo "$tmplist" | grep RUNNING  |  grep "\-db\-" | \
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
	echo "$tmplist" | grep RUNNING  |  grep "\-app\-" | \
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
