#!/bin/bash

if [ -f ".ossutilconfig" ]; then
    rm ossutilconfig.zip -f
    zip -r -m -e ossutilconfig.zip .ossutilconfig
fi

# -m   move into zipfile (delete OS files)
# -e   encrypt
