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
            # AppleInterfaceStyle = "Dark";
            KeyRepeat = 2;
            InitialKeyRepeat = 30;
            ApplePressAndHoldEnabled = false;
        };

        WindowManager = {
          StandardHideWidgets = true;
          StageManagerHideWidgets = true;
        };

        finder = {
          FXPreferredViewStyle = "clmv";
        };

        dock = {
          orientation = "left";
          autohide = false;
          tilesize = 40;
          show-recents = false;

          persistent-others = [];

          persistent-apps = [
            { app = "/Applications/EuDic.app"; }
            { app = "/Applications/TickTick.app"; }
            { app = "/Applications/Lark.app"; }

            { spacer = { small = true; }; }

            { app = "/Applications/Obsidian.app"; }
            { app = "/Applications/Google Chrome.app"; }

            { spacer = { small = true; }; }

            { app = "/Applications/WezTerm.app"; }
            { app = "/Applications/ChatGPT.app"; }
            { app = "/Applications/ChatGPT Classic.app"; }
          ];

        };

        trackpad.Clicking = true;          # tap to click
    };

    system.activationScripts.postActivation.text = ''
      /usr/bin/sudo -u ${user} /usr/bin/killall Dock || true
    '';

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
            "zoxide" # better cd
            "emacs" # secondary editor than vim
            "neovim" # modern vim
            # "python@3.14" # python
            # "kimi-code" # kimi coding agent
            # "rbenv" # ruby version manager
            # "mole" # tw93's awesome mac storage cleaner
            # "llm" # simon willison's cli llm
            # "tree" # print cli dir tree
            "ripgrep" # text search dependency
            "lazygit" # git in cli
        ];
        casks = [
            # utilities
            "stats"
            "karabiner-elements"
            "rectangle"
            "hiddenbar"
            "snipaste"
            "raycast"

            # devtool
            "wezterm"
            # "claude-code"
            "codexbar"
            "codex"
            "chatgpt"
            "chatgpt-classic"

            # daily
            "google-chrome"
            "eudic"
            "ticktick"
            "obsidian"
            "nutstore"
        ];
    };
}
