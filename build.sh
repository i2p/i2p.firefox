#! /usr/bin/env bash
set -e 

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
cd "$SCRIPT_DIR" || exit 1

. "$SCRIPT_DIR/i2pversion"

if [ -f i2pversion_override ]; then
    . "$SCRIPT_DIR/i2pversion_override"
fi

. "$SCRIPT_DIR/config.sh"

if [ -f config_overide.sh ]; then
  . "$SCRIPT_DIR/config_override.sh"
fi

COUNT="Ten Nine Eight Seven Six Five Four Three Two One"

which java
JAVA=$(java --version | tr -d 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\n' | cut -d ' ' -f 2 | cut -d '.' -f 1 | tr -d '\n\t\- ')

if [ "$JAVA" -lt "14" ]; then
  echo "Java 14+ must be used to compile with jpackage, java is $JAVA"
  exit 1
fi
if [ "$JAVA" -lt "17" ]; then
  echo "It is highly recommended that you use Java 17+ to build release packages"
fi

if [ -z "${JAVA_HOME}" ]; then
  JAVA_HOME=`type -p java|xargs readlink -f|xargs dirname|xargs dirname`
fi
if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  JAVA_HOME=`type -p java|xargs readlink -f|xargs dirname|xargs dirname`
fi
echo "Building with: $JAVA, $JAVA_HOME"
sleep 5s

HERE="$PWD"
if [ ! -d "$HERE/../i2p.i2p.jpackage-build/" ]; then
  git clone -b "$VERSION" https://i2pgit.org/i2p-hackers/i2p.i2p "$HERE/../i2p.i2p.jpackage-build/"
  tar --exclude="$HERE/../i2p.i2p.jpackage-build/.git" -cvzf i2p.i2p.jpackage-build.tar.gz "$HERE/../i2p.i2p.jpackage-build/"
fi
cd "$HERE/../i2p.i2p.jpackage-build/"
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
mkdir -p build
cp "$I2P_JARS"/*.jar build
if [ ! -f "$HERE/build/jna.jar" ]; then
  wget -O "$HERE/build/jna.jar" "https://repo1.maven.org/maven2/net/java/dev/jna/jna/$JNA_VERSION/jna-$JNA_VERSION.jar"
fi

if [ ! -f "$HERE/build/jna-platform.jar" ]; then
  wget -O "$HERE/build/jna-platform.jar" "https://repo1.maven.org/maven2/net/java/dev/jna/jna-platform/$JNA_VERSION/jna-platform-$JNA_VERSION.jar"
fi

if [ ! -f "$HERE/build/i2pfirefox.jar" ]; then
  wget -O "$HERE/build/i2pfirefox.jar" "https://github.com/eyedeekay/i2p.plugins.firefox/releases/download/$I2PFIREFOX_VERSION/i2pfirefox.jar"
fi

cd java
"$JAVA_HOME"/bin/javac -d ../build -classpath "$HERE/build/i2pfirefox.jar:$HERE/build/jna.jar":"$HERE/build/jna-platform.jar":"$HERE/build/i2p.jar":"$HERE/build/router.jar":"$HERE/build/routerconsole.jar" \
  net/i2p/router/CopyConfigDir.java \
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

rm -rf I2P

make src/I2P/config

"$JAVA_HOME"/bin/jpackage --type app-image --name I2P --app-version "$I2P_VERSION" \
  --verbose \
  --java-options "-Xmx512m" \
  --java-options "--add-opens java.base/java.lang=ALL-UNNAMED" \
  --java-options "--add-opens java.base/sun.nio.fs=ALL-UNNAMED" \
  --java-options "--add-opens java.base/java.nio=ALL-UNNAMED" \
  --java-options "--add-opens java.base/java.util.Properties=ALL-UNNAMED" \
  --java-options "--add-opens java.base/java.util.Properties.defaults=ALL-UNNAMED" \
  $JPACKAGE_OPTS \
  --resource-dir build \
  --app-content src/I2P/config \
  --input build --main-jar launcher.jar --main-class net.i2p.router.WinLauncher

cp "$I2P_PKG/licenses/"* license/
cp "$HERE/../i2p.i2p.jpackage-build/LICENSE.txt" license/I2P.txt
