# Code-Server Docker Image for React-Native development #

## Author ##

Teng Fu

Email: teng.fu@teleware.com

## Base Image ##
This is the docker image for React-Native development.

## Additional installed packages ##

- Code-Server

- Anaconda

- JDK, JRE ver 8

- Virsual Stuido Code Extensions

- Bazel

- Android-SDK

- Android-NDK

- Node.JS

- React-Native-CLI

- Yarn

- EXPO-CLI


## Docker Registry Repo ##

-  tftwdockerhub/vscode_server_react_native:latest

## Usage ##

on virtual machines


```
sudo docker pull tftwdockerhub/vscode_server_react_native:latest
```

Remember the accessiable target port is __8889__, the --privileged is better to add in the cmd if you wish to attach your android device to this docker container.
```
sudo docker run --privileged -d -p 8889:8888 -p 19000:19000 -p 19001:19001 -v \<project-dir-path\>:/app vscode_server_react_native:latest
```

In local browser, remember the target port is __8889__ and the token string on CLI screen
```
http://\<vm-ipaddress-or-dns\>:8889
```