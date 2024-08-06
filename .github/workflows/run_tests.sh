#!/bin/bash
SCHEME='JustChat'
PROJECT='JustChat/JustChat.xcodeproj'
DESTINATION='platform=iOS Simulator,name=iPhone 15,OS=18.0'
xcodebuild test -project $PROJECT -scheme $SCHEME -sdk iphonesimulator -destination "$DESTINATION" CODE_SIGNING_ALLOWED='NO'
