#!/bin/bash

DESTINATION='platform=iOS Simulator,name=iPhone 16,OS=18.0'
WORKSPACE='JustChat.xcworkspace'
SCHEME='iOS_CI'
xcodebuild test -workspace $WORKSPACE -scheme $SCHEME -sdk iphonesimulator -destination "$DESTINATION"
