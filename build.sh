#!/bin/bash
set -e 

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR" || exit 1

. i2pversion

if [ -f i2pversion_override ]; then
  . i2pversion_override
fi

. config.sh

if [ -f config_overide.sh ]; then
  . config_override.sh
fi

COUNT="Ten Nine Eight Seven Six Five Four Three Two One"

JAVA=$(java --version | tr -d 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\n' | cut -d ' ' -f 2 | cut -d '.' -f 1 | tr -d '\n\t\- ')

if [ "$JAVA" -lt "14" ]; then
  echo "Java 14+ must be used to compile with jpackage, java is $JAVA"
  exit 1
fi
if [ "$JAVA" -lt "17" ]; then
  echo "It is highly recommended that you use Java 17+ to build release packages"
fi
sleep 5s

if [ -z "${JAVA_HOME}" ]; then
  JAVA_HOME=`type -p java|xargs readlink -f|xargs dirname|xargs dirname`
  echo "Building with: $JAVA, $JAVA_HOME"
fi

echo "cleaning"
./clean.sh

HERE="$PWD"
if [ ! -d "$HERE/../i2p.i2p.jpackage-build/" ]; then
  git clone https://i2pgit.org/i2p-hackers/i2p.i2p "$HERE/../i2p.i2p.jpackage-build/"
fi
cd "$HERE/../i2p.i2p.jpackage-build/"
git checkout "$VERSION"
for i in $COUNT; do
  echo -n "$i...."; sleep 1s
done
ant distclean pkg || true

cd "$HERE"
I2P_PKG="$HERE/../i2p.i2p.jpackage-build/pkg-temp"
RES_DIR="$HERE/../i2p.i2p.jpackage-build/installer/resources"
I2P_JARS="$I2P_PKG/lib"
I2P_JBIGI="$HERE/../i2p.i2p.jpackage-build/installer/lib/jbigi"


echo "compiling custom launcher"
mkdir build
cp "$I2P_JARS"/*.jar build
if [ ! -f "$HERE/build/jna.jar" ]; then
  wget -O "$HERE/build/jna.jar" "https://repo1.maven.org/maven2/net/java/dev/jna/jna/$JNA_VERSION/jna-$JNA_VERSION.jar"
fi

if [ ! -f "$HERE/build/jna-platform.jar" ]; then
  wget -O "$HERE/build/jna-platform.jar" "https://repo1.maven.org/maven2/net/java/dev/jna/jna-platform/$JNA_VERSION/jna-platform-$JNA_VERSION.jar"
fi

cd java
"$JAVA_HOME"/bin/javac -d ../build -classpath "$HERE/build/jna.jar":"$HERE/build/jna-platform.jar":"$HERE/build/i2p.jar":"$HERE/build/router.jar":"$HERE/build/routerconsole.jar" \
  net/i2p/router/Elevator.java \
  net/i2p/router/Shell32X.java \
  net/i2p/router/WinLauncher.java \
  net/i2p/router/WindowsUpdatePostProcessor.java \
  net/i2p/router/WinUpdateProcess.java

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
  --java-options "-Xmx512m" \
  --java-options "--add-opens java.base/java.lang=ALL-UNNAMED" \
  --java-options "--add-opens java.base/sun.nio.fs=ALL-UNNAMED" \
  --java-options "--add-opens java.base/java.nio=ALL-UNNAMED" \
  $JPACKAGE_OPTS \
  --resource-dir build \
  --input build --main-jar launcher.jar --main-class net.i2p.router.WinLauncher
