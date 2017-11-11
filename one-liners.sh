### Virtualbox

# Delete all VMs:
vboxmanage list vms | cut -d' ' -f1 | sed -E 's/"//g' | xargs -n1 vboxmanage unregistervm --delete

# Force shutdown all VMs
vboxmanage list runningvms |cut -f1 -d' ' | sed 's/"//g' | xargs -n1 -I{} vboxmanage controlvm "{}" poweroff
