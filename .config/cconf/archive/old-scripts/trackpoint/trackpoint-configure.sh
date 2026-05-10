#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

sudo cp -v 71-pointingstick-override.hwdb /etc/udev/hwdb.d/
sudo udevadm hwdb --update
