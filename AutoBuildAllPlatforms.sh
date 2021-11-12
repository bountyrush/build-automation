curDir=$PWD
./AutoBuilder.sh iOS $1 $2
cd "$curDir"
./AutoBuilder.sh Android $1 $2
cd "$curDir"