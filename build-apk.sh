#!/usr/bin/env bash
# Construye un APK de depuración. Requiere Node.js, Android SDK y conexión inicial.
set -euo pipefail
cd "$(dirname "$0")/.."
if ! command -v npm >/dev/null 2>&1; then echo 'ERROR: Instala Node.js y npm.' >&2; exit 1; fi
if ! command -v adb >/dev/null 2>&1 && [[ -z "${ANDROID_HOME:-}${ANDROID_SDK_ROOT:-}" ]]; then
  echo 'ERROR: No se detecta Android SDK. Instala Android Studio y configura ANDROID_HOME.' >&2; exit 1
fi
npm install
mkdir -p www/ruffle
# Copia los archivos de Ruffle desde el paquete npm instalado.
cp -R node_modules/@ruffle-rs/ruffle/. www/ruffle/
if [[ ! -d android ]]; then npx cap add android; fi
npx cap sync android
cd android
if [[ -x ./gradlew ]]; then ./gradlew assembleDebug; else echo 'ERROR: No se encontró android/gradlew.' >&2; exit 1; fi
printf '\nAPK generado en: %s\n' "$PWD/app/build/outputs/apk/debug/app-debug.apk"
