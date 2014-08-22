#!/bin/sh

exec play `ls ~/.sounds/* | sort -R | head -n1`
