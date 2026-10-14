rm ./android/app/jks
keytool  -genkey -keystore "./android/app/jks" -alias jks -keyalg RSA -keysize 2048 -validity 20000