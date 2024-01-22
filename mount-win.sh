#!/usr/bin/bash
# Mount /dev/nvme0n1p5 to /tmp/mount/win
# Usage: mount-win.sh [mount|umount]

if [ "$1" == "mount" ]; then
	sudo mkdir -p /mnt/win
	sudo mount /dev/nvme0n1p5 /mnt/win
elif [ "$1" == "umount" ]; then
	sudo umount /mnt/win
else
	echo "Usage: mount_win.sh [mount|umount]"
fi

