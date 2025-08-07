#!/bin/sh

if [ "$USER"x != "rootx" ]
then
    echo Must be run as root!
    exit 1
fi

show_help () {
    echo "Use option -D to specify a raid device (mdX)."
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
RAIDDEV=""

while getopts "h?D:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    D)  RAIDDEV=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

MDADM=$(which mdadm)
if [ -z ${MDADM} ]
then
    echo "Binary mdadm is not installed! Exiting..."
    exit 1
fi

if [ -z ${RAIDDEV} ]
then
    echo "No raid device specified! Exiting..."
    exit 1
else
    faulty_disk=`/sbin/mdadm -D /dev/$RAIDDEV | awk '/faulty/ {print $6}' `
    check_string=''

    if [ "${faulty_disk}" = "${check_string}" ]
    then
        echo "OK. No Faulty disk"
        exit 0
    else
        echo "Repairing $faulty_disk"
        /sbin/mdadm --remove /dev/$RAIDDEV $faulty_disk
        /sbin/mdadm --add /dev/$RAIDDEV $faulty_disk
    fi
fi
