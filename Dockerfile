FROM anademn/xfce
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  	apt-transport-https ca-certificates curl gnupg apt-utils --no-install-recommends


# Install icons, themes and wallpaper
RUN apt-get install -y wget
RUN wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install.sh | DESTDIR="$HOME/.icons" sh && \
    eval `dbus-launch --sh-syntax` && \
		xfconf-query -c xsettings -p /Net/IconThemeName -s Papirus-Dark
COPY wallpaper.jpg Pictures/
ENV XFDESKTOP_IMAGE_FILE_0 "/home/anademn/Pictures/wallpaper.jpg"
RUN apt-get install -y arc-theme && \
    eval `dbus-launch --sh-syntax` && \
		xfconf-query -c xsettings -p /Net/ThemeName -s Arc-Dark
RUN mkdir ~/.config/xfce4/terminal && \
    curl -L "https://raw.githubusercontent.com/chriskempson/base16-xfce4-terminal/master/base16-chalk.dark.terminalrc" > ~/.config/xfce4/terminal/terminalrc


# Install atom editor
RUN curl -sSL https://packagecloud.io/AtomEditor/atom/gpgkey | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'

RUN apt-get update && apt-get install -y \
    atom git gconf2 gconf-service gvfs-bin libasound2 libcap2 libgconf-2-4 libgtk2.0-0 libnotify4 \
    libnss3 libxkbfile1 libxss1 libxtst6 libx11-xcb-dev xdg-utils --no-install-recommends && rm -rf /var/lib/apt/lists/*


# Install ffmpeg and pulse audio
RUN apt-get update && apt-get install -y ffmpeg pulseaudio-utils pavucontrol


# Install node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs


# Sudo and node package dependencies
RUN apt-get install -y sudo
RUN apt-get install -y python2.7 git-all pkg-config libncurses5-dev libssl-dev libnss3-dev libexpat-dev


# Install pass and image editors
RUN apt-get install -y pass inkscape gimp


# Install emojis
RUN apt-get install -y ttf-bitstream-vera
ADD https://github.com/eosrei/twemoji-color-font/releases/download/v1.4/TwitterColorEmoji-SVGinOT-Linux-1.4.tar.gz /
RUN tar zxf TwitterColorEmoji-SVGinOT-Linux-1.4.tar.gz && cd TwitterColorEmoji-SVGinOT-Linux-1.4 && ./install.sh


# Install firefox dev ed
RUN apt-get install -y bzip2
ADD https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US /tmp/firefox.tar.bz2
RUN mkdir /opt/firefox && tar xvjf /tmp/firefox.tar.bz2 -C /opt
COPY FirefoxDevEd.desktop /usr/share/applications/

EXPOSE 1935
ENV DEBIAN_FRONTEND newt
