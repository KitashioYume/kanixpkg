{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; 
  
  networking.enableIPv6 = false;  # 禁用IPv6以避免某些神秘问题

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  powerManagement.enable = true;
  networking.extraHosts = 
    ''
    127.0.0.1 localhost
    140.82.114.25 alive.github.com
    140.82.114.25 live.github.com
    185.199.111.154 github.githubassets.com
    140.82.114.22 central.github.com
    185.199.109.133 desktop.githubusercontent.com
    185.199.108.133 camo.githubusercontent.com
    185.199.110.133 github.map.fastly.net
    146.75.121.194 github.global.ssl.fastly.net
    140.82.121.3 gist.github.com
    185.199.110.153 github.io
    140.82.121.3 github.com
    192.0.66.2 github.blog
    140.82.121.5 api.github.com
    185.199.111.133 raw.githubusercontent.com
    185.199.111.133 user-images.githubusercontent.com
    185.199.111.133 favicons.githubusercontent.com"
    185.199.111.133 avatars5.githubusercontent.com
    185.199.108.133 avatars4.githubusercontent.com
    185.199.109.133 avatars3.githubusercontent.com
    185.199.110.133 avatars2.githubusercontent.com
    185.199.111.133 avatars1.githubusercontent.com
    185.199.110.133 avatars0.githubusercontent.com
    185.199.110.133 avatars.githubusercontent.com
    140.82.121.10 codeload.github.com
    52.217.70.140 github-cloud.s3.amazonaws.com
    3.5.21.220 github-com.s3.amazonaws.com
    16.15.180.231 github-production-release-asset-2e65be.s3.amazonaws.com
    54.231.162.49 github-production-user-asset-6210df.s3.amazonaws.com
    52.217.166.217 github-production-repository-file-5c1aeb.s3.amazonaws.com
    185.199.108.153 githubstatus.com
    140.82.114.18 github.community
    51.137.3.17 github.dev
    140.82.113.22 collector.github.com
    13.107.42.16 pipelines.actions.githubusercontent.com
    185.199.111.133 media.githubusercontent.com
    185.199.110.133 cloud.githubusercontent.com
    185.199.109.133 objects.githubusercontent.com
  '';
  
  boot.kernelParams = [ "nvidia-drm.modeset=1"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt          
      intel-media-driver
      libvdpau-va-gl
    ];
  };
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    powerManagement.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.nvidia.prime = {
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
  };


  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-mozc
      fcitx5-gtk
      qt6Packages.fcitx5-qt
      fcitx5-fluent
      (fcitx5-rime.override {
        rimeDataPkgs = [
          pkgs.rime-ice
	  pkgs.rime-data
        ];
      })
    ];
  };

  
  services.xserver.enable = true;
  programs.xwayland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.displayManager.defaultSession = "niri";
  
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  environment.sessionVariables = {
    GDK_GL = "gles";
    };


#  programs.hyprland = {
#    enable = true;
#    withUWSM = true;
#    xwayland.enable = true;
#  };
  programs.niri.enable = true; 
  
    
  programs.fish.enable = true;

  nixpkgs.config.allowUnsupportedSystem = true;
  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };
  nix.settings = {
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  
      "https://mirrors.ustc.edu.cn/nix-channels/store"  
      "https://cache.nixos.org/"  
    ];
    experimental-features = [ "nix-command" "flakes" ];  
  };
  
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
    };
    theme = "breeze";
    wayland.compositor = "kwin";
    package = pkgs.kdePackages.sddm;
  };
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "hibernate";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "ignore";
      LidSwitchIgnoreInhibited = "yes";
    };
  };
  users.users.yume = {
    isNormalUser = true;
    description = "yume";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    packages = with pkgs; [
      tree
    ];
    home = "/home/yume";
  };
  programs.clash-verge = {
    enable = true;
    tunMode = true;                 
    serviceMode = true;             
  };
  nixpkgs.config.allowUnfree = true;
  programs.firefox = {
    enable = true;
  };

  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; 
  services.tumbler.enable = true; 
  security.soteria.enable = true;
  services.udisks2.enable = true;
  
  services.flatpak={
    enable = true;
  };


  environment.systemPackages = with pkgs; [
    vim
    jq 
    libvterm
    easyeffects
    swayidle
    clash-verge-rev
    wget
    foot
    waybar
    kitty
    git
    fastfetch
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc 
    alacritty
    home-manager
    emacs-pgtk
    brightnessctl
    gnome-extension-manager
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    vscode
    localsend
    qq
    btop
    yazi
    hyfetch
    papirus-icon-theme
    gnome-themes-extra
    fuzzel
    vesktop
    curl
    pipx
    python314Packages.pip
    kdePackages.kate
    imv
    sbcl
    cmake
    python314
    libgcc
    gcc
    llm
    xwayland-satellite
    telegram-desktop
  ];
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
  programs.direnv.enable = true;
  services.emacs = {
    enable = true;
    defaultEditor = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;
  
  security.polkit.enable = true;
  services.dbus.enable = true;
  
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true; 
    jack.enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ 
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      nerd-fonts.jetbrains-mono
      source-han-sans
      source-han-serif
      maple-mono.NF-CN
      font-awesome
      nerd-fonts.fira-code
      nerd-fonts.noto
      nerd-fonts.fira-mono
      fira-code 
      fira-code-symbols
      wqy_zenhei
      wqy_microhei      
      emacs-pgtk
      fd
      ripgrep
    ];
  };
  fonts.fontconfig.defaultFonts = {
    serif = [ "Noto Serif" "Noto Serif CJK SC" ];
    sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
    monospace = [ "Fira Code" ];
  };


  environment.pathsToLink = [
    "/share/fastfetch"
    "/share/wayland-sessions"
    "/share/fcitx5" 
  ];

  environment.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
  };
  
  services.openssh.enable = true;
  time.hardwareClockInLocalTime = true;

  system.stateVersion = "25.11";

}
