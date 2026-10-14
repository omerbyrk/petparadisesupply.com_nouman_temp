#!/bin/bash

set -e
cd $WEBVIEW_BASE_PATH
source ./bin/run_variable.sh
sh ./bin/force_debug_control.sh
echo "${BLUE}Running configuration........$NC"
flutter pub run configuration:main -f ./assets/config/build-configuration.yaml -d
set +e

flutter run --no-enable-impeller 

