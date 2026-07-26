{ user, ... }:

{
    # Determinate already manages the Nix daemon, so nix-darwin shouldn't
    nix.enable = false;
    
    nixpkgs.config.allowUnfree = true;
    nixpkgs.hostPlatform = "aarch64-darwin"; # sue x86_64-darwin for Intel CPU

    system.primaryUser = user;
    users.users.${user} = {
      home = "/Users/${user}";
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
        inherit user;
        autoMigrate = true;
    };
    homebrew = {
        enable = true;

        onActivation.cleanup = "none"; # `zap` remove anything not listed here
        onActivation.autoUpdate = true; # update homebrew index
        onActivation.upgrade = false; # but don't update software

        brews = [
            "git-delta" # used by lazygit for better diff
            "herdr" # modern agentic tmux
            "fx" # terminal json viewer
            "zsh-autosuggestions" # zsh plugin
            "zsh-syntax-highlighting" # zsh plugin
            "zoxide" # better cd
            "emacs" # secondary editor than vim
            "neovim" # modern vim
            "python@3.14" # python
            "kimi-code" # kimi coding agent
            "rbenv" # ruby version manager
        ];
        casks = [
            "wezterm"
            "stats"
            "claude-code"
        ];
    };
}
