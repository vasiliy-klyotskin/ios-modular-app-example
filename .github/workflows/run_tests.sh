#!/bin/bash

# Common
DESTINATION='platform=iOS Simulator,name=iPhone 16,OS=18.0'
WORKSPACE='JustChat.xcworkspace'
SCHEME='iOS_CI'
xcodebuild test -workspace $WORKSPACE -scheme $AUTHENTICATION_SCHEME -sdk iphonesimulator -destination "$DESTINATION" CODE_SIGNING_ALLOWED='NO'

# Authentication
AUTHENTICATION_SCHEME='AuthenticationTests'
echo 'Running tests for Authentication'


# Primitives
PRIMITIVES_SCHEME='PrimitivesTests'
echo 'Running tests for Primitives'
xcodebuild test -workspace $WORKSPACE -scheme $PRIMITIVES_SCHEME -sdk iphonesimulator -destination "$DESTINATION" CODE_SIGNING_ALLOWED='NO'
