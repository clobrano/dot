#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel

sudo dnf install -y lame\* --exclude=lame-devel

sudo dnf group -y upgrade --with-optional Multimedia
sudo dnf group -y update multimedia sound-and-video
