#!/usr/bin/env python

"""
map-scan-type.py
================

Maps scan type from one type of code to another.

Types are:

vol: SUR
ele: RHI
azi: VERT

The script takes one of either key/value (upper or lower-case) and returns
the mapped version.
"""

import sys
arg = sys.argv[1]

d = {
'vol': 'SUR',
'ele': 'RHI',
'azi': 'VER'
}

rd = dict([(value, key) for key, value in d.items()])
found = False

for dct in (d, rd):
    for key, value in dct.items():
        if arg.lower() == key.lower():
            print(value)
            found = True


if not found:
    raise Exception('Cannot match scan type: {0}'.format(arg))


