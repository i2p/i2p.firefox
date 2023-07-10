FROM debian:sid

## Originally found at: https://yusuke.blog/2021/10/19/3149 and updated to Java 20.
## This does not work yet.

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y curl fakeroot unzip gnupg dos2unix make nsis* dos2unix curl jq

# install JDK
RUN curl --output /opt/java20.zip https://download.java.net/java/GA/jdk20.0.1/b4887098932d415489976708ad6d1a4b/9/GPL/openjdk-20.0.1_windows-x64_bin.zip \
    && cd /opt/  \
    && unzip java20.zip \
    && rm java20.zip 
ENV JAVA_HOME /opt/jdk-20.0.1

# install Wine
RUN apt-get update
RUN apt install --install-recommends  wine wine64* wine-binfmt fonts-wine -y
RUN wine --version
RUN wine wineboot --init

# install WIX TOOLSET
RUN mkdir /opt/wix311 \
    && cd /opt/wix311  \
    && curl -L --output /opt/wix311/wix311.zip https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311-binaries.zip  \
    && unzip wix311.zip \
    && rm wix311.zip
    
# WIX TOOLSET is requring .NET.
RUN curl --output winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks &&\
    chmod +x winetricks && \
    mv -v winetricks /usr/local/bin

# DONNO why dotnet48 installation fails with "warning: exit status 5 - user selected 'Cancel' "
# https://forum.winehq.org/viewtopic.php?f=8&t=35724
#ENV WINEPREFIX=/dotnet-test
#RUN /usr/local/bin/winetricks --optout -q dotnet48

ENV WINEPATH /opt/jdk-20.0.1/bin\;/opt/wix311

WORKDIR /root
COPY . /root
RUN echo "wine /opt/jdk-20.0.1/bin/jpackage.exe $@" > /opt/jdk-20.0.1/bin/jpackage
RUN chmod +x /opt/jdk-20.0.1/bin/jpackage
CMD ./buildscripts/build.sh