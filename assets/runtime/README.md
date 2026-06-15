Put the embedded runtime archive here when building a full offline APK.

Expected file name:

- bootstrap-aarch64.zip

The archive should unpack into the app private runtime root with this layout:

- usr/bin/bash
- usr/bin/pkg or usr/bin/apt
- usr/lib
- home

Large runtime archives are intentionally not committed to this repository.
