#!/bin/bash

set -e
cd $WEBVIEW_BASE_PATH
sh ./bin/force_remote_control.sh
set +e
rm -r ./build/app
rm -r ./build/ios


sh ./bin/build_apk.sh
echo "Uploading .app to appetize!"
curl --http1.1 $appetize_url -F "file=@build/app/outputs/flutter-apk/app-release.apk" -F "platform=android" -F "appPermissions.run=public" >./build/android_appetize.json
echo "You can access the test simulator via below link!!!!"
cat ./build/android_appetize.json | jq -r '.publicURL'