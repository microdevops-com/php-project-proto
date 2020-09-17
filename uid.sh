#!/bin/bash
if [[ -n $SUDO_UID ]]; then
	echo $SUDO_UID
else
	echo $UID
fi
