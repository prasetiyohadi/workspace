#!/bin/sh

if [ "$USER"x != "rootx" ]
then
    echo Must be run as root!
    exit 1
fi

show_help () {
    echo "Option -H to specify hostname"
    echo "Option -N to specify IP address and netmask in x.x.x.x/xx form"
    echo "Option -V to specify VLAN"
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
NEWHOSTNAME=""
NEWIPADDR=""
VLAN=""

while getopts "h?H:N:V:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    H)  NEWHOSTNAME=$OPTARG
        ;;
    N)  NEWIPADDR=$OPTARG
        ;;
    V)  VLAN=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

IPCALC=$(which ipcalc)
if [ -z ${IPCALC} ]
then
    apt-get update
    apt-get install -y ipcalc
fi

CURRHOSTNAME=$(hostname)
if [ -z ${NEWHOSTNAME} ]
then
    echo Skipping hostname configuration
elif [ "$CURRHOSTNAME" != "$NEWHOSTNAME" ]
then
    sed -i "s/$CURRHOSTNAME/$NEWHOSTNAME/g" /etc/hostname
    sed -i "s/$CURRHOSTNAME/$NEWHOSTNAME/g" /etc/hosts
    sed -i "s/debian9-template-rizal-123456/$NEWHOSTNAME/g" /etc/hosts
    hostname $NEWHOSTNAME
else
    echo Hostname already configured
fi

INTERFACE=$(egrep 'auto eth|auto ens|allow-hotplug eth|allow-hotplug ens' /etc/network/interfaces | awk '{print $NF}')
if [ -z ${NEWIPADDR} ]
then
    echo Skipping network configuration
elif [ -z ${VLAN} ]
then
    cat << EOF >> /etc/network/interfaces
#iface $INTERFACE inet static
#    address `ipcalc -b $NEWIPADDR | grep Address | awk '{print $2}'`
#    netmask `ipcalc -b $NEWIPADDR | grep Netmask | awk '{print $2}'`
#    gateway `ipcalc -b $NEWIPADDR | grep HostMin | awk '{print $2}'`
EOF
else
    cat << EOF >> /etc/network/interfaces
#iface $INTERFACE inet manual
#
#auto $INTERFACE.$VLAN
#iface $INTERFACE.$VLAN inet static
#    address `ipcalc -b $NEWIPADDR | grep Address | awk '{print $2}'`
#    netmask `ipcalc -b $NEWIPADDR | grep Netmask | awk '{print $2}'`
#    gateway `ipcalc -b $NEWIPADDR | grep HostMin | awk '{print $2}'`
EOF
fi
