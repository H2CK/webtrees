#!/bin/bash
HTTP_ONLY=${DISABLE_SSL:-FALSE}
if [ "$HTTP_ONLY" = "TRUE" ]
then
  a2dissite webtrees
  a2ensite webtrees_insecure
else
  a2dissite webtrees_insecure
  a2ensite webtrees
fi
