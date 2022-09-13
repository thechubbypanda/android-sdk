FROM docker.io/archlinux/archlinux:base-devel
RUN pacman -Syu --needed --noconfirm git gradle
ARG user=makepkg
RUN useradd --system --create-home $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user
RUN git clone https://aur.archlinux.org/yay.git \
  && cd yay \
  && makepkg -sri --needed --noconfirm \
  && cd \
  && rm -rf .cache yay
RUN yay -Sy --noconfirm android-sdk-cmdline-tools-latest android-sdk-build-tools android-sdk-platform-tools android-platform \
  && rm -rf .cache \
  && sudo pacman -Scc --noconfirm
USER root
RUN yes | /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager --licenses
ENV ANDROID_HOME=/opt/android-sdk
