cd "$(dirname "$0")"
if [ -d .git ]; then
  echo "This is a git repository folder. So not updating! Try in a non-git repository folder to update the files"
  exit 0
else
  echo "Trying to update by fetching from build-automation git repository..."
fi;

rootDir=$PWD
 mkdir cache
 cd cache
 git clone https://github.com/bountyrush/build-automation.git
 cd build-automation
 
#rsync -ax --exclude [relative path to directory to exclude] /path/from /path/to
rsync -ax --exclude ../../config . $rootDir

cd $rootDir
rm -rf ./cache

