#!/usr/bin/env bash

ssh $(virsh domifaddr $1 --source agent --interface enp1s0 | grep ipv4 |grep -v lo| awk '{ print $4 }' | cut -d / -f 1)
