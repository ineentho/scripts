

```
# Download scripts to ./lib
./get-scripts

# Create template
mkdir -p /vmstorage/vdi-templates/
mkdir -p /vmstorage/vdis/
./lib/create-coreos-vdi -d /vmstorage/vdi-templates/
echo 'export VDI_TEMPLATE="/vmstorage/vdi-templates/coreos_production_1465.6.0.vdi"' > env
echo 'export VDI_STORAGE="/vmstorage/vdis/"' >> env

# Create Virtualbox VM
(source env; ./create-instance)

# Remove the config-drive before starting again
vboxmanage storageattach coreos-X --storagectl "IDE Controller" --port 0 --device 0 --medium none

```


## Misc links
https://coreos.com/os/docs/latest/booting-on-virtualbox.html
