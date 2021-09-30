#!/bin/env bash

## Get new release binaries
curl -s https://api.github.com/repos/bromite/bromite/releases/latest |
    grep "_SystemWebView\\.apk\|brm.*txt" | cut -d : -f 2,3 | tr -d \" | wget -qi -
rm -rf ./*txt*

VERSION=`curl -s https://api.github.com/repos/bromite/bromite/releases/latest | grep "tag_name" | cut -d : -f 2,3 | tr -d \",`
echo Version: $VERSION

## CHECK
SHAOLD1="$(sha256sum prebuilt/arm64/SystemWebView.apk)"
SHAOLD2="$(sha256sum prebuilt/x86/SystemWebView.apk)"
SHAOLD3="$(sha256sum prebuilt/arm/SystemWebView.apk)"
SHANEW1="$(sha256sum ./arm64_SystemWebView.apk)"
SHANEW2="$(sha256sum ./x86_SystemWebView.apk)"
SHANEW3="$(sha256sum ./arm_SystemWebView.apk)"

if
    [ "$SHAOLD1" == "$SHANEW1" ]
    [ "$SHAOLD2" == "$SHANEW2" ]
    [ "$SHAOLD3" == "$SHANEW3" ]
then
    echo "No new release found"
else
    echo "New release found, updating binaries"
    mv -f arm64_* prebuilt/arm64/SystemWebView.apk
    mv -f x86_* prebuilt/x86/SystemWebView.apk
    mv -f arm_* prebuilt/arm/SystemWebView.apk
    git add prebuilt
    git commit -sa -m "Update release $VERSION"
fi

## CLEAN
rm -rvf ./*apk*
