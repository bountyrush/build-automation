cd "$(dirname "$0")"
rootDir=$PWD
 mkdir cache
 cd cache
 git clone https://github.com/bountyrush/build-automation.git
 cd build-automation
 
#rsync -ax --exclude [relative path to directory to exclude] /path/from /path/to
rsync -ax --exclude ../../config . $rootDir

cd $rootDir
rm -rf ./cache

