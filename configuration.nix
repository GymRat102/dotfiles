{ ... }:

{
    # Determinate already manages the Nix daemon, so nix-darwin shouldn't
    nix.enable = false;
    
    nixpkgs.config.allowUnfree = true;
    nixpkgs.hostPlatform = "aarch64-darwin"; # sue x86_64-darwin for Intel CPU

    system.primaryUser = "weijianduan";
    users.users.weijianduan = {
      home = "/Users/weijianduan";
    };
    system.stateVersion = 6;

    system.defaults = {
        NSGlobalDomain = {
            AppleInterfaceStyle = "Dark";
        };
        dock.autohide = false;
        trackpad.Clicking = true;          # tap to click
    };

    nix-homebrew = {
        enable = true;
        user = "weijianduan";
        autoMigrate = true;
    };
    homebrew = {
        enable = true;

        onActivation.cleanup = "none"; # `zap` remove anything not listed here
        onActivation.autoUpdate = true;
        # onActivation.extraFlags = [ "--force" ]

        brews = [
            "git-delta" # used by lazygit for better diff
            "herdr"
        ];
        casks = [
            "wezterm"
            "stats"
        ];
    };
}

