#!/usr/bin/env bash
# Ejecutar UNA vez con internet. Después el APK funciona 100% offline.
set -e
cd "$(dirname "$0")/.."
npm install
rm -rf www/ruffle && mkdir -p www/ruffle
cp -r node_modules/@ruffle-rs/ruffle/. www/ruffle/
[ -d android ] || npx cap add android
# Forzar pantalla horizontal
sed -i 's/<activity /<activity android:screenOrientation="sensorLandscape" /' android/app/src/main/AndroidManifest.xml 2>/dev/null || true
npx cap sync android
echo "Listo. Ejecuta: npx cap open android  (Build > Build APK)"
