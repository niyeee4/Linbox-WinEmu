#!/bin/bash
set -e

echo "Setting up Android SDK..."
export JAVA_HOME=/usr/local/sdkman/candidates/java/21.0.10-ms
export PATH=$JAVA_HOME/bin:$PATH

mkdir -p android-sdk
if [ ! -f cmdline-tools.zip ]; then
    echo "Downloading cmdline-tools..."
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip
fi

if [ ! -d android-sdk/cmdline-tools/latest ]; then
    echo "Extracting cmdline-tools..."
    unzip -q cmdline-tools.zip -d android-sdk
    mkdir -p android-sdk/cmdline-tools/latest
    mv android-sdk/cmdline-tools/bin android-sdk/cmdline-tools/latest/
    mv android-sdk/cmdline-tools/lib android-sdk/cmdline-tools/latest/
    mv android-sdk/cmdline-tools/source.properties android-sdk/cmdline-tools/latest/
fi

export ANDROID_HOME=$(pwd)/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH

echo "Accepting licenses..."
yes | sdkmanager --licenses --sdk_root=$ANDROID_HOME

echo "Installing platforms;android-35 and build-tools..."
sdkmanager --sdk_root=$ANDROID_HOME --install "platforms;android-35" "build-tools;35.0.0" "platform-tools"

echo "Building APK..."
./gradlew assembleDebug

echo "Build successful! APK is located under app/build/outputs/apk/debug/"
