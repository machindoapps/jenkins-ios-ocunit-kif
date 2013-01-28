#!/bin/bash

set -x
# do not exit immediately on non-zero return values
set +e
set -o verbose
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer/

cd path-to/MyApp;

# Build and run unit tests, with nice junit style output for Jenkins reports.
xcodebuild -target MyAppUnitTests \
-sdk iphonesimulator \
-configuration Debug \
TEST_AFTER_BUILD=YES \
clean build | /usr/bin/ocunit2junit

# Now run kif integration tests on the simulator.
# Script based on this:
# http://www.leonardoborges.com/writings/2012/05/03/build-automation-with-xcode-4-dot-3-kif-and-jenkins/

# Kill the simulator if it is running
pid=$(ps -fe | grep '[i]Phone Simulator' | awk '{print $1}')
if [[ -n $pid ]]; then
    kill $pid
else
    echo "No iOS Simulators running."
fi

# remove temp KIF files
if [[ -d /tmp/KIF-* ]]; then
    rm /tmp/KIF-* 2>&1
fi

echo "Building NexusIntegrationTests"
xcodebuild -target "MyAppIntegrationTests" -configuration Release -sdk iphonesimulator clean build

OUT_FILE=/tmp/KIF-$$.out
echo "Running KIF Integration Tests"

/usr/local/bin/waxsim -f "iphone" "build/Release-iphonesimulator/MyAppIntegrationTests.app" > $OUT_FILE 2>&1
cat $OUT_FILE

result=`exec grep -c "TESTING FINISHED: 0 failures" $OUT_FILE`

# mark the build as unstable
if [ "$result" = '0' ]; then
    echo "KIF Integration Tests Failed"
    # replace this http address with the url of your CI server, to obtain the cli jar
    curl -OL http://localhost/jnlpJars/jenkins-cli.jar
    java -jar jenkins-cli.jar set-build-result unstable
fi

