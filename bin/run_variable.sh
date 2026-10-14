export android_bundle_id=$(yq e '.flutter_application_id.android.id' assets/config/build-configuration.yaml)
export ios_bundle_id=$(yq e '.flutter_application_id.ios.id' assets/config/build-configuration.yaml)

