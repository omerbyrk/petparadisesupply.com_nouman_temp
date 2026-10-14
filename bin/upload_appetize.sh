#!/bin/bash

set -e
cd $WEBVIEW_BASE_PATH
sh ./bin/force_remote_control.sh
set +e
rm -r ./build/ios

sh ./bin/build_ios_simulator.sh
(cd build/ios/iphonesimulator && zip -qr Runner.zip Runner.app)
echo "Uploading .app to appetize!"
curl --http1.1 $appetize_url -F "file=@build/ios/iphonesimulator/Runner.zip" -F "platform=ios" -F "appPermissions.run=public" >./build/ios_appetize.json
echo "You can access the test simulator via below link!!!!"
cat ./build/ios_appetize.json | jq -r '.publicURL'
