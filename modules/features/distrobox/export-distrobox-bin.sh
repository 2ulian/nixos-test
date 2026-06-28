#!/bin/sh

if [ ! -d "$HOME/.local/distrobox-bin" ]
then
	mkdir -p .local/distrobox-bin
fi

if [ ! -f "$HOME/.local/bin/distrobox_sudo_askpass" ]
then
	if [ ! -d "$HOME/.local/bin" ]
	then
		mkdir $HOME/.local/bin
		ln -sf /usr/bin/distrobox-host-exec $HOME/.local/bin/distrobox_sudo_askpass
	else
		ln -sf /usr/bin/distrobox-host-exec $HOME/.local/bin/distrobox_sudo_askpass
	fi
fi

for bin in $(/run/current-system/sw/bin/distrobox-enter --root -n cachy -- bash -c '/usr/bin/ls -p /usr/bin | grep -v /')
do
	if [ ! -f "$HOME/.local/distrobox-bin/$bin" ]
	then
		"/run/current-system/sw/bin/distrobox-enter" --root -n cachy  --  bash -c "/usr/bin/distrobox-export -b /usr/bin/$bin --export-path $HOME/.local/distrobox-bin"
		PATH=$(echo $PATH | sed "s#:$HOME/.local/distrobox-bin##")
		sed -i "1a export PATH=$PATH\n$HOME/nixos-config/modules/features/distrobox/run-distrobox-root.sh $bin \$@\nif [[ \$? -eq 1 ]]; then exit 0; fi" $HOME/.local/distrobox-bin/$bin
	fi
done

$HOME/nixos-config/modules/features/distrobox/clean-distrobox-bin.sh