UNITY_HUB=/Applications/Unity/Hub/Editor
versions=()
target=$1
productEnv=$2
skipMakingUnityBuild=$3
echo "Usage: ./AutoBuilder.sh PLATFORM_NAME(iOS/Android) ENVIRONMENT(dev/release/draft) SKIP_UNITY_EXPORT(1)"

loadEnv () {
  set -a
  [ -f ./config/env/.env ] && . ./config/env/.env
  set +a
}

loadVersions () {
    FILE="./config/Versions.txt"
    if test -f "$FILE"; then
            while IFS= read -r line
        do
            if ! [ -z "$line" ]; then
                versions+=("$line")
            fi
        done < "./config/Versions.txt"
    else
        version=$(grep m_EditorVersion temp/ProjectSettings/ProjectVersion.txt | cut -d':' -f2 | head -n 1 | xargs)
        versions=($version)
    fi

    
    echo "Versions to build : $versions"
}

makeUnityBuild () {
    currentDirectoryName=${PWD##*/}
    parent=$(dirname "$(pwd)") # #Get parent directory - Alternative echo $(cd ../ && pwd) or "${PWD%/*}"

    mkdir -p "$parent/$currentDirectoryName/temp"
    rsync -a "$parent/Assets" "$parent/$currentDirectoryName/temp/" --delete
    rsync -a "$parent/ProjectSettings" "$parent/$currentDirectoryName/temp/" --delete
    rsync -a "$parent/Packages" "$parent/$currentDirectoryName/temp/" --delete
    rsync -a "$parent/Library" "$parent/$currentDirectoryName/temp/" --delete

    echo 'Copied unity project to $pwd/temp'


    if [ ${#versions[@]} -eq 0 ]; then
        versions=()
        echo "Set unity version to use in Versions.txt file"
        printf "%s\n" "${versions[@]}" > config/Versions.txt
        exit 0
    else
        echo "Using versions set in Versions.txt file..."
    fi


    printf "%s\n" "${versions[@]}"
    printf "%s\n" "${target}"

    for version in "${versions[@]}"
    do 
        echo "Building for target : $target ($version)"
        UNITY_APP="$UNITY_HUB/$version/Unity.app/Contents/MacOS/Unity"
        #mkdir -p "$runningDirectory/Builds/$target"
        echo "Running project available at $(pwd)/temp"
        $UNITY_APP \
        -gvh_disable \
        -batchmode \
        -quit \
        -nographics \
        -buildTarget $target \
        -silent-crashes \
        -logfile /dev/stdout \
        -projectPath "$(pwd)/temp" \
        -executeMethod VoxelBusters.CoreLibrary.Editor.NativePlugins.Build.TargetBuilder.Build
    done
    #"$(pwd)/$each/log.txt" \
    #https://fargesportfolio.com/unity-generic-auto-build/
    echo "-----------------------------------------------------------"
    grep -ri --include=\*log.txt 'error CS' *
    grep -ri --include=\*log.txt 'Error building Player' *
    grep -ri --include=\*log.txt 'Failed building' *
    echo "###########################################################"
    grep -ri --include=\*log.txt 'Finished building' *
    echo "***********************************************************"
}

loadEnv
loadVersions

runningDirectory=$(pwd)

if ! [ $skipMakingUnityBuild -eq 1 ]; then
    makeUnityBuild
fi


# Run Fastlane to build the project
echo "Running Fastlane...."
#Load environment variables
set -o allexport
source ./config/.env
set +o allexport

cd "$runningDirectory/tools"
# iOS project in builds/ios and Android project in builds/android folders


targetTemp=$(echo "$target" | tr "[:upper:]" "[:lower:]")
echo "Running fastlane for $productEnv environment : $targetTemp"
if [ $productEnv = 'create' ]
then
    bundle exec fastlane $targetTemp 'create' --verbose
elif [ $productEnv = 'dev' ] 
then
    bundle exec fastlane $targetTemp 'dev' --verbose
elif [ $productEnv = 'release' ] 
then
    bundle exec fastlane $targetTemp 'release' --verbose
elif [ $productEnv = 'draft' ] 
then
    bundle exec fastlane $targetTemp 'draft' --verbose
else
    bundle exec fastlane $targetTemp 'dev' --verbose
fi

cd "$runningDirectory"
