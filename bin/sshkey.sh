#!/bin/bash
if [ $# -eq 1 ] 
then
	echo "Usage: `basename $0` option"
	echo "  -c   --createclientkey gen cur user key"
	echo "  -m   --copykeytohost add the key to client"
fi

case $1 in
	-c)
		ssh-keygen -t dsa
		echo "the key is ~/.ssh/id_dsa.pub"
		;;
	-m)
		cat id_dsa.pub >> ~/.ssh/authorized_keys2
		chmod 644 ~/.ssh/authorized_keys2
		echo "done"
		;;
esac
