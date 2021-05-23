#!/bin/bash
set -e 

. i2pversion

JAVA=$(java --version | tr -d 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\n' | cut -d ' ' -f 2 | cut -d '.' -f 1 | tr -d '\n\t ')

if [ "$JAVA" -lt "14" ]; then
	echo "Java 14+ must be used to compile with jpackage, java is $JAVA"
	exit 1
fi


if [ -z "${JAVA_HOME}" ]; then
	JAVA_HOME=`type -p java|xargs readlink -f|xargs dirname|xargs dirname`
	echo "Building with: $JAVA, $JAVA_HOME"
fi

echo "cleaning"
./clean.sh

HERE="$PWD"
cd "$HERE/../i2p.i2p/"
git checkout "$VERSION"
ant pkg

cd "$HERE"
RES_DIR="$HERE/../i2p.i2p/installer/resources"
I2P_JARS="$HERE/../i2p.i2p/pkg-temp/lib"
I2P_PKG="$HERE/../i2p.i2p/pkg-temp"

echo "compiling custom launcher"
mkdir build
cp "$I2P_JARS"/*.jar build
cd java
"$JAVA_HOME"/bin/javac -d ../build -classpath "$HERE"/build/i2p.jar:"$HERE"/build/router.jar net/i2p/router/WinLauncher.java
cd ..

#echo "building launcher.jar"
cd build
"$JAVA_HOME"/bin/jar -cf launcher.jar net
cd ..

if [ -z $I2P_VERSION ]; then 
    I2P_VERSION=$("$JAVA_HOME"/bin/java -cp build/router.jar net.i2p.router.RouterVersion | sed "s/.*: //" | head -n 1 | sed 's|-|.|g')
fi
echo "preparing to invoke jpackage for I2P version $I2P_VERSION"


"$JAVA_HOME"/bin/jpackage --type app-image --name I2P --app-version "$I2P_VERSION" \
  --verbose \
  $JPACKAGE_OPTS \
  --resource-dir build \
  --input build --main-jar launcher.jar --main-class net.i2p.router.WinLauncher
