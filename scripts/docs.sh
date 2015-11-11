#!/bin/sh

PATH=/usr/local/bin:/usr/bin:/bin:/usr/libexec

if [ -z "${SRCROOT}" ]; then
    SRCROOT="$(pwd)"
fi

plist_file="${SRCROOT}/ADAlert/Info.plist"
version="$(PlistBuddy -c "Print :CFBundleShortVersionString" "$plist_file")"

appledoc \
    -p ADAlert \
    -o "${SRCROOT}/../docs/$version" \
    -v ${version} \
    -c "Anton Dobkin" \
    --company-id "com.droopls.adalert" \
    --keep-undocumented-objects \
    --keep-undocumented-members \
    --create-html \
    --no-create-docset \
    --ignore "ADAlert/Sources/Private" \
    --ignore "ADAlert/Sources/Categories" \
    --ignore ".m" \
    ADAlert/Sources
