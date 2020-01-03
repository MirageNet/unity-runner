#!/usr/bin/env bash

# The following tests are 2019 mode (requires Unity 2019.2.11f1 or later)
# Reference: https://docs.unity3d.com/2019.3/Documentation/Manual/CommandLineArguments.html
#
# Testing in EditMode
#

if [ -n "$INPUT_WORKDIR" ] ; then
  cd "$INPUT_WORKDIR"
fi

FILE_PATH=UnityLicenseFile.ulf

echo "$UNITY_LICENSE" | tr -d '\r' > $FILE_PATH

pwd

ls -l

xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' \
/opt/Unity/Editor/Unity \
  -batchmode \
  -nographics \
  -logfile /dev/stdout \
  -silent-crashes \
  $INPUT_ARGS
