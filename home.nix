{ config, pkgs, inputs, ... }:

{
  imports = [
  ];

  home.packages = [
   # pkgs.emacs
    pkgs.pywalfox-native
    pkgs.pywal
   
  ];
  home.username = "yume";
  home.homeDirectory = "/home/yume";
  home.stateVersion = "25.11";
  programs.git.enable = true;
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [
      pkgs.pywalfox-native
    ];
  };
  services.emacs = {
    enable = true;
    #defaultEditor = true;
  };
  dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark"; 
      package = (pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";     
        accent = "mauve";      
      });
    };
    gtk4.theme = config.gtk.theme; 
  };
  home.pointerCursor = {
    name = "Adwaita"; # 鼠标主题名称，如 "Bibata-Modern-Classic"
    package = pkgs.adwaita-icon-theme; # 主题包
    size = 24; # 鼠标大小
    gtk.enable = true; # 同步GTK设置
    x11.enable = true; # 同步X11设置
  };
  xdg.desktopEntries."qq" = {
    name = "qq";
    exec = "env -u WAYLAND_DISPLAY qq %U";
    terminal = false;
    categories = [ "Application" ];
  };  

}
