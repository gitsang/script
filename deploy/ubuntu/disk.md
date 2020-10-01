
# other command
df -h
fdisk -l
lsblk

## info
LVM (logical volume manager)
PV: physical volume
VG: volume group
PE: physcial len
LV: logical volume

## create
pvcreate /dev/sda{1,2,3}
vgcreate ubuntu-vg
lvcreate -L 204G -n ubuntu-lv1 ubuntu-vg

## extend
- create physical volume from sdb1
`pvcreate /dev/sdb1`
- extend sdb1 to ubuntu-vg
`vgextend ubuntu-vg /dev/sdb1`
- extend 5G to ubuntu-lv1
`lvextend -L +5G /dev/ubuntu-vg/ubuntu-lv1`

## remove
lvremove
vgremove
pvremove

## display
pvdisplay
vgdisplay
lvdisplay

## mount disk error
`mount: wrong fs type, bad option, bad superblock on /dev/ubuntu-vg/ubuntu-lv2`
sudo mkfs -t ext4 /dev/ubuntu-vg/ubuntu-lv2
sudo mount /dev/ubuntu-vg/ubuntu-lv2 /xxx


