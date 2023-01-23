#! /usr/bin/env bash
set -e 

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)/..
cd "$SCRIPT_DIR" || exit 1

. "$SCRIPT_DIR/i2pversion"

if [ -f i2pversion_override ]; then
    . "$SCRIPT_DIR/i2pversion_override"
fi

. "$SCRIPT_DIR/config.sh"

if [ -f "$SCRIPT_DIR/config_override.sh" ]; then
  . "$SCRIPT_DIR/config_override.sh"
fi

COUNT="Ten Nine Eight Seven Six Five Four Three Two One"

which java
export JAVA=$(java --version | tr -d 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\n' | cut -d ' ' -f 2 | cut -d '.' -f 1 | tr -d '\n\t\- ')

if [ "$JAVA" -lt "14" ]; then
  echo "Java 14+ must be used to compile with jpackage, java is $JAVA"
  exit 1
fi
if [ "$JAVA" -lt "17" ]; then
  echo "It is highly recommended that you use Java 17+ to build release packages"
fi

if [ -z "${JAVA_HOME}" ]; then
  export JAVA_HOME=`type -p java|xargs readlink -f|xargs dirname|xargs dirname`
fi
if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  export JAVA_HOME=`type -p java|xargs readlink -f|xargs dirname|xargs dirname`
fi
echo "Building with: $JAVA, $JAVA_HOME"
sleep 5s

#SCRIPT_DIR="$PWD"
export I2P_PKG="$SCRIPT_DIR/../i2p.i2p.jpackage-build/pkg-temp"
export RES_DIR="$SCRIPT_DIR/../i2p.i2p.jpackage-build/installer/resources"
export I2P_JARS="$I2P_PKG/lib"
export I2P_JBIGI="$SCRIPT_DIR/../i2p.i2p.jpackage-build/installer/lib/jbigi"
export I2P_JBIGI_JAR="$SCRIPT_DIR/../i2p.i2p.jpackage-build/build/jbigi.jar"
if [ ! -d "$SCRIPT_DIR/../i2p.i2p.jpackage-build/" ]; then
  git clone --depth=1 -b "$VERSION" https://i2pgit.org/i2p-hackers/i2p.i2p "$SCRIPT_DIR/../i2p.i2p.jpackage-build/"
fi
cd "$SCRIPT_DIR/../i2p.i2p.jpackage-build/"
OLDEXTRA=$(find . -name RouterVersion.java -exec grep 'String EXTRA' {} \;)
if [ -z "$EXTRA" ]; then
  export EXTRACODE="win"
  export EXTRA="    public final static String EXTRA = \"-$EXTRACODE\";"
fi
find . -name RouterVersion.java -exec sed -i "s|$OLDEXTRA|$EXTRA|g" {} \;
git checkout -b "i2p-$VERSION-$EXTRACODE" && git commit -am "i2p-$VERSION-$EXTRACODE"
git pull --tags
git archive --format=tar.gz --output="$SCRIPT_DIR/../i2p.firefox/i2p.i2p.jpackage-build.tar.gz" "i2p-$VERSION-$EXTRACODE"

for i in $COUNT; do
  echo -n "$i...."; sleep 1s
done
ant distclean pkg || true
ant jbigi

cd "$SCRIPT_DIR"

mkdir -p src/I2P/config
rm -rf "src/I2P/config/geoip" "src/I2P/config/webapps" "src/I2P/config/certificates"
cp -v "$RES_DIR/clients.config" "src/I2P/config/"
cp -v "$RES_DIR/wrapper.config" "src/I2P/config/"
#grep -v 'router.updateURL' $(RES_DIR)/router.config > src/I2P/config/router.config
cat router.config > src/I2P/config/router.config
cat i2ptunnel.config > src/I2P/config/i2ptunnel.config
cp -v "$RES_DIR/hosts.txt" "src/I2P/config/hosts.txt"
cp -R "$RES_DIR/certificates" "src/I2P/config/certificates"
cp -R "$RES_DIR/eepsite" "src/I2P/config/eepsite"
mkdir -p src/I2P/config/geoip
cp -v "$RES_DIR/GeoLite2-Country.mmdb.gz" "src/I2P/config/geoip/GeoLite2-Country.mmdb.gz"
cp -R "$I2P_PKG/webapps" "src/I2P/config/webapps"
cd src/I2P/config/geoip && gunzip GeoLite2-Country.mmdb.gz; cd ../../..

echo "compiling custom launcher"
mkdir -p "$SCRIPT_DIR/build"
cp "$I2P_JARS"/*.jar "$SCRIPT_DIR/build"
cp "$I2P_JBIGI_JAR" "$SCRIPT_DIR/build"
if [ ! -f "$SCRIPT_DIR/build/jna.jar" ]; then
  wget -O "$SCRIPT_DIR/build/jna.jar" "https://repo1.maven.org/maven2/net/java/dev/jna/jna/$JNA_VERSION/jna-$JNA_VERSION.jar"
fi

if [ ! -f "$SCRIPT_DIR/build/jna-platform.jar" ]; then
  wget -O "$SCRIPT_DIR/build/jna-platform.jar" "https://repo1.maven.org/maven2/net/java/dev/jna/jna-platform/$JNA_VERSION/jna-platform-$JNA_VERSION.jar"
fi

if [ ! -f "$SCRIPT_DIR/build/i2pfirefox.jar" ]; then
  wget -O "$SCRIPT_DIR/build/i2pfirefox.jar" "https://github.com/eyedeekay/i2p.plugins.firefox/releases/download/$I2PFIREFOX_VERSION/i2pfirefox.jar"
fi

for dll in "$I2P_JBIGI/"*windows*.dll; do
  jar uf "$SCRIPT_DIR/build/jbigi.jar" "$dll"
done

cd java
"$JAVA_HOME"/bin/javac -d ../build -classpath "$SCRIPT_DIR/build/i2pfirefox.jar:$SCRIPT_DIR/build/jna.jar":"$SCRIPT_DIR/build/jna-platform.jar":"$SCRIPT_DIR/build/i2p.jar":"$SCRIPT_DIR/build/router.jar":"$SCRIPT_DIR/build/routerconsole.jar":"$SCRIPT_DIR/build/jbigi.jar" \
  net/i2p/router/CopyConfigDir.java \
  net/i2p/router/Elevator.java \
  net/i2p/router/Shell32X.java \
  net/i2p/router/WindowsServiceUtil.java \
  net/i2p/router/WinLauncher.java \
  net/i2p/router/WindowsUpdatePostProcessor.java \
  net/i2p/router/WinUpdateProcess.java \
  net/i2p/router/WindowsServiceUtil.java \
  net/i2p/router/ZipUpdateProcess.java

cd ..

#echo "building launcher.jar"
cd "$SCRIPT_DIR/build"
"$JAVA_HOME"/bin/jar -cf launcher.jar net
cd ..
