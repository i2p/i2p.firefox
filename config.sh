#! /usr/bin/env bash

## If you need to use a different JVM, JDK, or other utility from
# build.sh, set it in this file, for example:

uname=$(uname)

#export PATH="$PATH:/c/Program Files/Java/jdk-17.0.3/bin/"
#export JAVA_HOME="/c/Program Files/Java/jdk-17.0.3"
# to use it for Oracle OpenJDK17

## Other potential values(NOT exhaustive):

if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
    PATH="/c/Program Files/Java/jdk-18.0.2/bin/:$PATH:/c/Program Files/Java/jdk-18.0.2/bin/"
    export PATH="/c/Program Files/Java/jdk-18.0.2/bin/:$PATH:/c/Program Files/Java/jdk-18.0.2/bin/"
    JAVA_HOME="/c/Program Files/Java/jdk-18.0.2"
    export JAVA_HOME="/c/Program Files/Java/jdk-18.0.2"
fi

if "${uname}" != "Linux"; then
    PATH="/c/Program Files/Java/jdk-18.0.2/bin/:$PATH:/c/Program Files/Java/jdk-18.0.2/bin/"
    export PATH="/c/Program Files/Java/jdk-18.0.2/bin/:$PATH:/c/Program Files/Java/jdk-18.0.2/bin/"
    JAVA_HOME="/c/Program Files/Java/jdk-18.0.2"
    export JAVA_HOME="/c/Program Files/Java/jdk-18.0.2"
fi

#export PATH="$PATH:/c/Program Files/Eclipse Adoptium/jdk-17.0.3/bin/"
#export JAVA_HOME="/c/Program Files/Eclipse Adoptium/jdk-17.0.3"
#export PATH="$PATH:/c/Program Files/OpenJDK/jdk-17.0.3/bin/"
#export JAVA_HOME="/c/Program Files/OpenJDK/jdk-17.0.3"

#BREAKS!
#export PATH=/c/Program Files/GraalVM/graalvm-ce-java17-22.0.0.2/bin
#export JAVA_HOME=/c/Program Files/GraalVM/graalvm-ce-java17-22.0.0.2
#BREAKS!
# might be fun to learn why this is broken

#WORKS WELL! GETS UPDATES AS SOON AS ORACLE! VIABLE ALTERNATIVE!
#export PATH="$PATH:/c/Program Files/Amazon Corretto/jdk17.0.3_6/bin/"
#export JAVA_HOME="/c/Program Files/Amazon Corretto/jdk17.0.3_6"
#WORKS WELL! GETS UPDATES AS SOON AS ORACLE! VIABLE ALTERNATIVE!

# These are all things I built the package with today(April 20, 2022, idk)

# Which will determine, of course, which java compilers you use and where
# your JAVA_HOME(and thus your bootclasspath jars and stuff) come from.
# So for you reddit nerds who are all into graalVM or whatever, this might
# be where you go to mess with that.

## Until 1.7.4, releases were built using Eclipse Adoptium OpenJDK
# but it lags behind a day or two in security updates which did become
# a major issue in April 2022. At this point it was migrated to Oracle's
# JDK distribution which was more up to date. Should you prefer, or simply
# wish to experiment with a different JVM, copy this file to `config_overrides.sh`
# and add your JAVA_HOME and $PATH changes.

# You can also use this to temporarily add applications into the PATH that are
# required to build this if you do not wish to edit your PATH across the entire
# Windows session, and for setting ANT_HOME
#export ANT_HOME="/c/apache-ant-1.10.9"
#export PATH="$PATH:$ANT_HOME/bin/"

if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
    PATH="$PATH:/c/Program Files (x86)/Windows Kits/10/App Certification Kit/"
    export PATH="$PATH:/c/Program Files (x86)/Windows Kits/10/App Certification Kit/"
fi

if "${uname}" != "Linux"; then
    PATH="$PATH:/c/Program Files (x86)/Windows Kits/10/App Certification Kit/"
    export PATH="$PATH:/c/Program Files (x86)/Windows Kits/10/App Certification Kit/"
fi