#!/bin/bash

name=$(cat name)
date=$(date +%Y.%m.%d)

rm "${name}-nopasaran-${date}.zip"

zip -j "${name}-nopasaran-${date}.zip" out/*
