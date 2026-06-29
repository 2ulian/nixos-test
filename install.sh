#!/bin/sh
if [[ $# != 0 ]]
then
	echo "Error: The script does not take arguments"
	exit 1
fi

echo -n "Enter configuration name: "
read name

if [[ $name == "" ]]
then
    echo "Error: No configuration name provided."
    exit 1
fi

dirname=$(dirname $0)

if [[ ! -d "$dirname/hosts/$name" ]] 
then
    echo -n "The configuration \"$name\" does not exist, would you like to create it? [Y/n] "
    read answer
    if [[ $answer == "" || $answer = "y" || $answer == "Y" ]]
    then
        cp -r $dirname/hosts/template $dirname/hosts/$name
        # in Configuration.nix file:
        sed -i "s/flake.nixosModules.configuration/flake.nixosModules.${name}Configuration/g" $dirname/hosts/$name/configuration.nix
        sed -i "s/networking.hostName = \"nixos\";/networking.hostName = \"${name}\";/g" $dirname/hosts/$name/configuration.nix
        sed -i "s/self.nixosModules.hardware/self.nixosModules.${name}Hardware/g" $dirname/hosts/$name/configuration.nix
        sed -i "s/self.nixosModules.disko/self.nixosModules.${name}Disko/g" $dirname/hosts/$name/configuration.nix

        # in default.nix file:
        sed -i "s/flake.nixosConfigurations.nixos/flake.nixosConfigurations.${name}/g" $dirname/hosts/$name/default.nix
        sed -i "s/self.nixosModules.configuration/self.nixosModules.${name}Configuration/g" $dirname/hosts/$name/default.nix

        # in disko.nix file:
        sed -i "s/flake.nixosModules.disko/flake.nixosModules.${name}Disko/g" $dirname/hosts/$name/disko.nix
        echo -n "On which device should we install NixOS ? (e.g. sda): "
        read device
        sed -i "s#device = \"\";#device= \"/dev/${device}\";#g" $dirname/hosts/$name/disko.nix
        echo -n "How many gigs of swap (e.g. 16): "
        read swap
        sed -i "s/swap.swapfile.size = \"\"/swap.swapfile.size = \"${swap}G\"/g" $dirname/hosts/$name/disko.nix
    
        # hardware config:
        nixos-generate-config --show-hardware-config --no-filesystems > $dirname/hosts/$name/hardware-configuration.nix
        sed -i "1 i\{ self, inputs, ... }: {\nflake.nixosModules.${name}Hardware =" $dirname/hosts/$name/hardware-configuration.nix
        sed -i '$ i\};' $dirname/hosts/$name/hardware-configuration.nix
        nix-shell -p nixfmt --run "nixfmt ${dirname}/hosts/${name}/hardware-configuration.nix"

        echo "New profile created"
    else
        exit 1
    fi
fi

echo -n "The installation will now start, everything on /dev/${device} will be wiped. Continue?  [Y/n] "
read answer
if [[ $answer == "" || $answer = "y" || $answer == "Y" ]]
then
    nix-shell -p disko --run "sudo disko --mode disko --flake .#${name}"
    sudo nixos-install --no-channel-copy --no-root-password --flake .#${name}
else
    exit 1
fi
