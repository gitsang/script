#!/bin/bash

if [ -f "config.json" ]; then
    rm config.zip -f
    zip -r -m -e config.zip config.json
fi

# -m   move into zipfile (delete OS files)
# -e   encrypt
