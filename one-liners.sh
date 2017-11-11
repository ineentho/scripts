### Virtualbox

# Delete all VMS:
vboxmanage list vms | cut -d' ' -f1 | sed -E 's/"//g' | xargs -n1 vboxmanage unregistervm --delete
