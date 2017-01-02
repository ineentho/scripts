#!/bin/bash

# This script is meant to be run from the host that
# the arch VM is going to run under.

if [[ -z $VDI_STORAGE ]]; then
  VDI_STORAGE="$HOME/vdi"
fi

if [[ -z $ISO ]]; then
  ISO="$HOME/iso/archlinux-2016.12.01-dual.iso"
fi

mkdir -p "$VDI_STORAGE"

function get_latest_vm {
  local max=0

  while read line; do
    if [[ $line =~ "\"arch\"" ]]; then
      if [[ 1 > $max ]]; then
        max=1
      fi
    fi

    vmreg="\"arch-([0-9]+)\""

    if [[ $line =~ $vmreg ]]; then
      num="${BASH_REMATCH[1]}"
      if [[ $num > $max ]]; then
        max=$num
      fi
    fi
  done <<< "$(VBoxManage list vms)"

  echo $max
}

function get_next_name {
  nextvm=$(($(get_latest_vm) + 1))

  if [[ $nextvm == 1 ]]; then
    name="arch"
  else
    name="arch-$nextvm"
  fi

  echo $name
}

function setup_vm {
  local vmname=$1
  hdfile="$VDI_STORAGE/$vmname.vdi"

  echo "Disk file: $hdfile"

  vboxmanage createhd --filename "$hdfile" --size $((1024 * 1024 * 2))
  vboxmanage createvm --name $vmname --ostype ArchLinux_64 --register

  vboxmanage storagectl $vmname --name "SATA Controller" --add sata --controller IntelAHCI
  vboxmanage storageattach $vmname --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $hdfile

  vboxmanage storagectl $vmname --name "IDE Controller" --add ide
  vboxmanage storageattach $vmname --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO"

  vboxmanage modifyvm $vmname --ioapic on
  vboxmanage modifyvm $vmname --boot1 dvd --boot2 disk
  vboxmanage modifyvm $vmname --memory 4096 --vram 128
  vboxmanage modifyvm $vmname --firmware efi
}

vmname=$(get_next_name)

setup_vm $vmname

vboxmanage startvm $vmname #--type headless

sleep 120

vboxmanage controlvm $vmname keyboardputscancode 02 82