#!/bin/bash
GROUPID=${GROUP_ID:-999}
groupmod -g $GROUPID docker-data 
