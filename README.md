0. Make sure you fill in config details with details about the app and metadata(screenshots)
1. List the platforms you want to build in Targets.txt
2. List the unity versions you want to test line by line in versions.txt file. (optional)
2. Run AutoBuilder.sh from terminal (ex: ./AutoBuilder.sh) 

* If AutoBuilder.sh is not getting executed, set permissions to it (ex: chmod 777 AutoBuilder.sh)

It copies the Assets, ProjectSettings and Packages folders to Temp folder and create the builds in Builds/$Target

./AutoBuilder.sh dev => This will make a dev build (iPA/APK)
./AutoBuilder.sh release => This will make a release build and upload

./AutoBuilder.sh release 1 => This will skip unity building and proceed with release step
