{ pkgs, inputs, ... }:
{
  home-manager.users.yume = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./noctalia.json);
    };
  };
}
