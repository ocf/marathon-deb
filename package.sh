#!/bin/bash

# This command is quite finicky, it doesn't appear to be able to be set up or
# split across lines without breaking it in strange ways. Thanks sbt.
sbt ';session clear-all ;set SystemloaderPlugin.projectSettings ++ SystemdPlugin.projectSettings ;packageDebianForLoader'

for file in /opt/marathon/target/packages/systemd*.deb; do
  # Rename the package to remove anything before (and including) the first
  # hyphen (-). This is to rename the package to have the correct name that the
  # .changes file contains. For some reason the .changes file contains a
  # different name for the package, but the correct checksums.
  mv -v "$file" /opt/marathon/target/"${file#*-}"
done
