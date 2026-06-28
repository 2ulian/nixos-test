#!/bin/sh

if [[ $USER != "root" ]]
then
	exit 0
fi

unset SUDO_USER SUDO_COMMAND SUDO_UID SUDO_GID DOAS_USER

distrobox-enter -n cachy -- sudo /usr/bin/$@

exit 1