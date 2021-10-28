fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios build
```
fastlane ios build
```
Build xcode project
### ios upload
```
fastlane ios upload
```
Upload ipa file to AppStoreConnect and check if AppStore site is configures correctly
### ios match_profile
```
fastlane ios match_profile
```
For matching certificates
### ios dev
```
fastlane ios dev
```
Build for dev
### ios release
```
fastlane ios release
```
Build for release

----

## Android
### android build
```
fastlane android build
```
Build gradle project
### android upload
```
fastlane android upload
```
Upload ipa file to AppStoreConnect and check if AppStore site is configures correctly
### android dev
```
fastlane android dev
```
Build for dev
### android release
```
fastlane android release
```
Build for release
### android draft
```
fastlane android draft
```
Upload a draft (useful for very first time setup)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
