# For pure c++ programming
# With Code-Server
# 0.3 with c++
# 0.4 with c++, cmake, java extension pack, mainly for JNI programming

FROM ubuntu:16.04

# the maintainer information
LABEL maintainer "Teng Fu <teng.fu@teleware.com>"

RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libcurl3-dev \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libpng12-dev \
        libzmq3-dev \
        libglib2.0-0 \
        libxext6 \
        libsm6 \
        libxrender1 \
        pkg-config \
        python-dev \
        rsync \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev \
        wget \
        curl \
        git \
        tree \
        iputils-ping \
        bzip2 \
        bash \
        ca-certificates \
        mercurial \
        subversion \
        bsdtar \
        openssl \
        locales \
        net-tools \
        && \
    rm -rf /var/lib/apt/lists/* 


# for NodeJS installation
# ------------------  Node SDK ----------
# according to https://github.com/nodesource/distributions
# target for NodeJS version 10.16

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# ------------------ Yarn installation ----------

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - 
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y \
    yarn \
    && rm -rf /var/lib/apt/lists/*

# ------------------  React Native SDK ----------
RUN npm install -g --unsafe-perm expo-cli

# must be after env installatin
# ------------- Code-Server --------------------
RUN locale-gen en_US.UTF-8

ENV CODE_VERSION="1.1156-vsc1.33.1"
RUN curl -sL https://github.com/codercom/code-server/releases/download/${CODE_VERSION}/code-server${CODE_VERSION}-linux-x64.tar.gz | tar --strip-components=1 -zx -C /usr/local/bin code-server${CODE_VERSION}-linux-x64/code-server

# setup extension path
# for Linux:
# Linux $HOME/.vscode/extensions
# here $HOME = "/root"
ENV VSCODE_EXTENSIONS "/root/.vscode/extensions"

# jdk, jre and cmake
RUN apt-get update && apt-get install --no-install-recommends -y \
    default-jdk \
    default-jre \
    cmake

# vscode extension installation
RUN mkdir -p ${VSCODE_EXTENSIONS}/cpptools && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-vscode/vsextensions/cpptools/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/cpptools extension
RUN mkdir -p ${VSCODE_EXTENSIONS}/vscode-java-pack && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/vscjava/vsextensions/vscode-java-pack/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/vscode-java-pack extension
RUN mkdir -p ${VSCODE_EXTENSIONS}/cmake-tools && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/vector-of-bool/vsextensions/cmake-tools/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/cmake-tools extension
RUN mkdir -p ${VSCODE_EXTENSIONS}/vscode-react-native && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/msjsdiag/vsextensions/vscode-react-native/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/vscode-react-native extension
RUN mkdir -p ${VSCODE_EXTENSIONS}/vscode-language-babel && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/mgmcdermott/vsextensions/vscode-language-babel/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/vscode-language-babel extension
RUN mkdir -p ${VSCODE_EXTENSIONS}/vscode-eslint && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/dbaeumer/vsextensions/vscode-eslint/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/vscode-eslint extension
RUN mkdir -p ${VSCODE_EXTENSIONS}/prettier-vscode && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/esbenp/vsextensions/prettier-vscode/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/prettier-vscode extension
RUN mkdir -p ${VSCODE_EXTENSIONS}/vscode-icons && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/vscode-icons-team/vsextensions/vscode-icons/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/vscode-icons extension
RUN mkdir -p ${VSCODE_EXTENSIONS}/vscode-npm-script && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/eg2/vsextensions/vscode-npm-script/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/vscode-npm-script extension
RUN mkdir -p ${VSCODE_EXTENSIONS}/path-intellisense && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/christian-kohler/vsextensions/path-intellisense/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/path-intellisense extension
RUN mkdir -p ${VSCODE_EXTENSIONS}/project-manager && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/alefragnani/vsextensions/project-manager/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/project-manager extension

# add in android version 
# ----------- Android SDK and NDK ------------
# according to https://github.com/nick-petrovsky/docker-android-sdk-ndk/blob/master/Dockerfile
ENV ANDROID_COMPILE_SDK="27"        \
    ANDROID_BUILD_TOOLS="28.0.3"    \
    ANDROID_SDK_TOOLS_REV="4333796" \
    ANDROID_CMAKE_REV="3.6.4111459" \
    ANDROID_CMAKE_REV_3_10="3.10.2.4988404"

ENV ANDROID_HOME=/opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/platform-tools/:${ANDROID_NDK_HOME}:${ANDROID_HOME}/ndk-bundle:${ANDROID_HOME}/tools/bin/

RUN    mkdir -p ${ANDROID_HOME} \
    && wget --quiet --output-document=${ANDROID_HOME}/android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_REV}.zip \
    && unzip -qq ${ANDROID_HOME}/android-sdk.zip -d ${ANDROID_HOME} \
    && rm ${ANDROID_HOME}/android-sdk.zip \
    && mkdir -p $HOME/.android \
    && echo 'count=0' > $HOME/.android/repositories.cfg

RUN    yes | sdkmanager --licenses > /dev/null \
    && yes | sdkmanager --update \
    && yes | sdkmanager 'tools' \
    && yes | sdkmanager 'platform-tools' \
    && yes | sdkmanager 'build-tools;'$ANDROID_BUILD_TOOLS \
    && yes | sdkmanager 'platforms;android-'$ANDROID_COMPILE_SDK \
    && yes | sdkmanager 'platforms;android-28' \
    && yes | sdkmanager 'extras;android;m2repository' \
    && yes | sdkmanager 'extras;google;google_play_services' \
    && yes | sdkmanager 'extras;google;m2repository' 

RUN    yes | sdkmanager 'cmake;'$ANDROID_CMAKE_REV \
       yes | sdkmanager --channel=3 --channel=1 'cmake;'$ANDROID_CMAKE_REV_3_10 \
    && yes | sdkmanager 'ndk-bundle' 
# ----------- Android SDK and NDK ------------

# ------------------ workspace --------------
# the default volume shared with host machine directory
# in the docker run 
# use docker run -v <absolute path of local folder>:/app
RUN mkdir /app

# workspace directory
WORKDIR /app

# Expose ports
# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888
# React-Native packager
EXPOSE 19000
EXPOSE 19001

# setup the react native packager hostname 
# for device access to container
# un-comment this for customised build
# or set this env when container runs
# for "react-native run" cmd
# ENV REACT_NATIVE_PACKAGER_HOSTNAME=$your_host_pc_name or IP address

# remove watch limit
COPY watchlimit.sh /
RUN chmod -R 777 /watchlimit.sh
# developer has two options for reset watch file limit
# 1. on Docker host machine, run all cmdlines in watchlimit.sh with 'sudo'
# this changes the host machine setting, so docker can directly mount the setting
# from host machine.
# 2. when launched in docker container, open Terminal, use following cmd
# /wathlimit.sh
# this cmd changes watch file limit in docker container without effect host machine

CMD ["code-server", "-N", "-p", "8888", "-e", "/root/.vscode/extensions"]