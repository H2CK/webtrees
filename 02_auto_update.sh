#!/bin/bash
UPDT_ON_START=${UPDATE_ON_START:-FALSE}
if [ "$UPDT_ON_START" = "TRUE"]
then
apt-get update -qq
apt-get upgrade -qy
fi
