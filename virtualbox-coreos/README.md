
```
# Folder structure
mkdir -p /vmstorage/vdi-templates/
mkdir -p /vmstorage/vdis/

# Download the latest `coreos_production_virtualbox_image.vmdk.bz2` from https://stable.release.core-os.net/amd64-usr/ and extract it
curl 'https://stable.release.core-os.net/amd64-usr/current/coreos_production_virtualbox_image.vmdk.bz2' | bzip2 -d > /vmstorage/vdi-templates/coreos_production_virtualbox_image.vmdk


# Create template
echo 'export VDI_TEMPLATE="/vmstorage/vdi-templates/coreos_production_virtualbox_image.vmdk"' > env
echo 'export DISCOVERY_URL="https://discovery.etcd.io/XXXXXXXXXXXX"' >> env
echo 'export VDI_STORAGE="/vmstorage/vdis"' >> env

# Create Virtualbox VM
(source env; ./create-instance)
```


## Misc links
https://coreos.com/os/docs/latest/booting-on-virtualbox.html
