#!/bin/bash

CONF_EXIST=`ls v2ray-conf*.json`

if [ -n "$CONF_EXIST" ]; then
    rm v2ray-conf.zip -f
    zip -m -e v2ray-conf.zip v2ray-conf*.json
fi

# -m   move into zipfile (delete OS files)
# -e   encrypt
