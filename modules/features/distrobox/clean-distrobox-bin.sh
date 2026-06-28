#/bin/sh

list_container=$("/run/current-system/sw/bin/distrobox-enter" --root -n cachy  --  bash -c "/usr/bin/ls -p /usr/bin | grep -v /")
list_out_container=$(/run/current-system/sw/bin/ls -p $HOME/.local/distrobox-bin | grep -v /)

communs=$(sort <<< "$list_container"$'\n'"$list_out_container" | uniq -u)

for bin in $communs
do
	rm -f $HOME/.local/distrobox-bin/$bin
done