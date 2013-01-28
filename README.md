jenkins-ios-ocunit-kif
======================

Jenkins build script for continuous integration and unit testing of iOS apps.

Uses Xcode cli, OCUnit and KIF integration testing framework.

Will mark a build as unstable if unit or integration tests fail.

Requirements:
* Jenkins server running on OSX with Xcode installed (as per standard iOS Jenkins setup).
* Ability to run iOS simulator from command line (e.g. using WaxSim)
* ocunit2junit Jenkins plugins for generation of Unit Test reports.
* Jenkins running as Desktop user
 
How to use:
    1. Modify script to match your app's targets and Jenkins URL (required for using jenkins' cli).
    2. Add build step in Jenkins, of type 'execute shell'.
    3. Paste in contents of jenkins-ios-ocunit-kif.sh
    4. Build, and enjoy painless CI of iOS apps.
