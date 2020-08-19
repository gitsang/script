#!/bin/bash

if [ -d "v2ray-conf" ]; then
    rm v2ray-conf.zip -f
    zip -r -m -e v2ray-conf.zip v2ray-conf/
fi

# -m   move into zipfile (delete OS files)
# -e   encrypt
