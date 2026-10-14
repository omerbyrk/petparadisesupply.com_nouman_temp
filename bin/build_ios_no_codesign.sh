#!/bin/bash

set -e
cd $WEBVIEW_BASE_PATH
sh ./bin/force_remote_control.sh
set +e

flutter build ios --no-codesign --release --no-tree-shake-icons --build-name=$build_name --build-number=$build_number


# This will take a minute or two and when it's done go to this folder : your-app/build/ios/Release-iphoneos and you should find your runner.app file. Create a folder named PayLoad next to it and copy and paste the runner.app file inside this folder. After that you wanna compress your Payload to get a new file named Payload.zip. Change its extension to ipa and you're done. You can now use whatever you want to codesign this ipa file.
