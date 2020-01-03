#!/usr/bin/env bash

# Request the manual activation file for activating unity personal
xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' \
  /opt/Unity/Editor/Unity \
    -batchmode \
    -nographics \
    -logFile /dev/stdout \
    -quit \
    -createManualActivationFile

FILE_NAME=Unity_v*.alf
FILE_PATH=$FILE_NAME

# Output the resulting file by copying
cp $FILE_NAME $HOME/$FILE_PATH

# Set resulting name as output variable
echo ::set-output name=filePath::$FILE_PATH

# Explain what to do next
echo "Use the file \"$FILE_PATH\" for manual activation."
echo "Set the contents of the resulting license file as the \$UNITY_LICENSE variabe."