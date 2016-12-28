#!/bin/bash

# A script for installing Arch according to my own prefernces.
# Designed to run as is on a clean VirtualBox machine with a
# single disk, booted from the offical ISO using EFI. This script
# only takes care of pre-restart operations.
#
# To run this script:
# curl -L https://rawgit.com/ineentho/scripts/master/setup-arch/install.sh | bash -

## Check pre-conditions

# Make sure we are booted in EFI mode
if [ ! -d "/sys/firmware/efi/efivars" ]; then
  echo Error: Not booted in EFI mode.
  exit 1
fi


## Preferences

loadkeys sv-latin1
timedatectl set-ntp true

## Partition & mount the disk
# We assume that the disk is /dev/sda since we only have one.

(
  echo o         # Create a GPT
  echo Y         # Confirm
  
  echo n         # Create new partition (EFI/boot)
  echo           # Choose default partition number
  echo           # Default first sector
  echo +512M{MG} # Choose size
  echo ef00      # Type: EFI System
  
  echo n         # Create new partition (Main)
  echo           # Choose default partition number
  echo           # Default first sector
  echo           # Default last sector (till the end)
  echo           # Default type (Linux filesystem)
  
  echo w         # Write the changes
  echo Y         # Confirm
) | gdisk /dev/sda

mkfs.vfat /dev/sda1
mkfs.btrfs /dev/sda2

mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot


## Installation

pacstrap /mnt base base-devel nvim zsh sudo
genfstab -U /mnt >> /mnt/etc/fstab

# Execute the rest of the installation inside of a chroot
cat << EOF | arch-chroot /mnt

ln -s /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "KEYMAP=sv-latin1" >> "/etc/vconsole.conf"

bootctl install

(
  echo "title          Arch Linux"
  echo "linux          /vmlinuz-linux"
  echo "initrd         /initramfs-linux.img"
  echo "options        root=/dev/sda2 rw"
) >> /boot/loader/entries/arch.conf

systemctl enable dhcpcd

curl -L https://rawgit.com/ineentho/scripts/master/setup-arch/post-install.sh >> post-install.sh
chmod +x post-install.sh

EOF

reboot
